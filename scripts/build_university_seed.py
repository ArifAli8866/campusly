#!/usr/bin/env python3
"""
Build a normalized university + campus seed dataset from scripts/university-source.txt.

Outputs:
  supabase/seed/universities.json   -> canonical institutions w/ campuses + aliases
  supabase/seed/campuses.csv        -> flat campus view (human QA)
  supabase/seed/review.csv          -> entries held back for admin review

Design decisions (see docs/ARCHITECTURE.md):
  * The source list mixes "Institution - Campus", "Institution, City" and bare
    institution names. We normalize all three shapes into one shape.
  * Known duplication (FAST-NUCES / NUCES, SZABIST / Shaheed Zulfiqar Ali Bhutto
    IST, Rawalpindi Women University twice, bare "University of X" repeating the
    "University of X - Y Campus" row) is resolved via ALIAS_TO_CANONICAL.
  * Entries that are not chartered universities, or that we could not corroborate,
    are emitted with status="pending_review" and are_active=false. They never
    appear in public listings but are visible + editable in /admin/universities.
"""

from __future__ import annotations

import csv
import json
import re
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = Path(__file__).resolve().parent / "university-source.txt"
OUT = ROOT / "supabase" / "seed"

# --------------------------------------------------------------------------
# 1. City -> (province, region) lookup.  Longest key wins.
# --------------------------------------------------------------------------
CITY_PROVINCE: dict[str, str] = {}

def _add(province: str, cities: str) -> None:
    for c in cities.split("|"):
        CITY_PROVINCE[c.strip().lower()] = province

_add("Punjab", "Lahore|Faisalabad|Rawalpindi|Multan|Gujranwala|Sialkot|Bahawalpur|Sargodha|"
     "Sheikhupura|Jhang|Gujrat|Sahiwal|Okara|Vehari|Rahim Yar Khan|Rahimyar Khan|Dera Ghazi Khan|"
     "D.G. Khan|Muzaffargarh|Chakwal|Mianwali|Bhakkar|Layyah|Narowal|Chiniot|Nankana Sahib|Kasur|"
     "Khanewal|Lodhran|Pakpattan|Toba Tek Singh|Attock|Jhelum|Hafizabad|Mandi Bahauddin|Khushab|"
     "Rajanpur|Bahawalnagar|Depalpur|Burewala|Kamalia|Taunsa|Kot Addu|Taxila|Wah|Wah Cantt|"
     "Chak Shahzad|Kala Shah Kaku|Pattoki|Kamoke|Wazirabad|Joharabad|Rachna|Sialkot Cantt|Gujranwala Cantt")

_add("Sindh", "Karachi|Hyderabad|Sukkur|Larkana|Larkano|Jamshoro|Nawabshah|Shaheed Benazirabad|"
     "Khairpur|Khairpur Mirs|Mirpur Khas|Mirpurkhas|Badin|Dadu|Ghotki|Shikarpur|Naushahro Feroze|"
     "Umerkot|Mithi|Tharparkar|Tandojam|Tando Allahyar|Sanghar|Kandhkot|Kashmore|Jacobabad|"
     "Shahdadkot|Gharo|Bhitshah|Hala|Matiari|Sujawal|Thatta|Sakrand|Ahsanabad|Gulshan|North Karachi|Lyari")

_add("Khyber Pakhtunkhwa", "Peshawar|Mardan|Abbottabad|Swat|Mingora|Kohat|Bannu|Dera Ismail Khan|"
     "D.I. Khan|Haripur|Nowshera|Swabi|Charsadda|Mansehra|Batkhela|Malakand|Buner|Shangla|"
     "Lakki Marwat|Tank|Hangu|Chitral|Wari|Sheringal|Nerian Sharif|Jalozai|Kamra|Kharian|Attock Cantt")

_add("Balochistan", "Quetta|Gwadar|Turbat|Khuzdar|Loralai|Zhob|Pishin|Noshki|Mastung|Kharan|Panjgur|"
     "Uthal|Wadh|Dera Murad Jamali|Nasirabad|Makran|Bolan|Sibi|Chaman|Dera Bugti")

_add("Islamabad Capital Territory", "Islamabad|Nilore|Islamabad Capital Territory|ICT|Kahuta|Gulberg Greens")

_add("Gilgit-Baltistan", "Gilgit|Hunza|Diamer|Ghizer|Baltistan|Skardu|Nagar|Ghanche|Astore")

_add("Azad Jammu and Kashmir", "Muzaffarabad|Mirpur|Rawalakot|Bagh|Kotli|Athmuqam|Neelum|Bhimber|Haveli|Poonch")

PROVINCES = [
    "Punjab",
    "Sindh",
    "Khyber Pakhtunkhwa",
    "Balochistan",
    "Islamabad Capital Territory",
    "Gilgit-Baltistan",
    "Azad Jammu and Kashmir",
]

# --------------------------------------------------------------------------
# 2. Canonicalization / aliases.
#    key = normalized (lowercased, punctuation-stripped) institution name
#    value = canonical name
# --------------------------------------------------------------------------
ALIAS_TO_CANONICAL: dict[str, str] = {}

def _alias(canonical: str, *aliases: str) -> None:
    for a in aliases:
        ALIAS_TO_CANONICAL[_norm(a)] = canonical

def _norm(value: str) -> str:
    value = unicodedata.normalize("NFKD", value)
    value = value.replace("&", " and ")
    value = re.sub(r"[^a-z0-9]+", " ", value.lower())
    return re.sub(r"\s+", " ", value).strip()

def slugify(value: str) -> str:
    return re.sub(r"-+", "-", re.sub(r"[^a-z0-9]+", "-", _norm(value).replace(" ", "-"))).strip("-")

# -- abbreviation lookup, keyed by canonical name ---------------------------
ABBREVIATIONS: dict[str, str] = {
    "FAST National University of Computer and Emerging Sciences": "FAST-NUCES",
    "National University of Sciences and Technology": "NUST",
    "Ghulam Ishaq Khan Institute of Engineering Sciences and Technology": "GIKI",
    "Lahore University of Management Sciences": "LUMS",
    "Institute of Business Administration": "IBA",
    "Institute of Business Management": "IoBM",
    "COMSATS University Islamabad": "CUI",
    "University of Engineering and Technology Lahore": "UET Lahore",
    "University of Engineering and Technology Taxila": "UET Taxila",
    "University of Engineering and Technology Peshawar": "UET Peshawar",
    "University of Engineering and Technology Mardan": "UET Mardan",
    "National University of Modern Languages": "NUML",
    "Shaheed Zulfiqar Ali Bhutto Institute of Science and Technology": "SZABIST",
    "Government College University Lahore": "GCU Lahore",
    "Government College University Faisalabad": "GCUF",
    "Government College University Hyderabad": "GCUH",
    "Quaid-i-Azam University": "QAU",
    "Quaid-i-Awam University of Engineering, Science and Technology": "QUEST",
    "Pakistan Institute of Engineering and Applied Sciences": "PIEAS",
    "Institute of Space Technology": "IST",
    "University of Management and Technology": "UMT",
    "University of Central Punjab": "UCP",
    "University of Lahore": "UOL",
    "University of Engineering and Technology": "UET",
    "NED University of Engineering and Technology": "NEDUET",
    "Virtual University of Pakistan": "VU",
    "Air University": "AU",
    "Bahria University": "BU",
    "University of Agriculture Faisalabad": "UAF",
    "University of Veterinary and Animal Sciences": "UVAS",
    "University of Punjab": "PU",
    "University of the Punjab": "PU",
    "University of Karachi": "UoK",
    "University of Peshawar": "UoP",
    "University of Sindh": "UoS",
    "University of Balochistan": "UoB",
    "University of Sargodha": "UoS Sargodha",
    "Bahauddin Zakariya University": "BZU",
    "Mehran University of Engineering and Technology": "MUET",
    "Dawood University of Engineering and Technology": "DUET",
    "Dow University of Health Sciences": "DUHS",
    "Aga Khan University": "AKU",
    "King Edward Medical University": "KEMU",
    "Fatima Jinnah Medical University": "FJMU",
    "Rawalpindi Medical University": "RMU",
    "National University of Medical Sciences": "NUMS",
    "Jinnah Sindh Medical University": "JSMU",
    "Liaquat University of Medical and Health Sciences": "LUMHS",
    "Khyber Girls Medical College": "KGMC",
    "Aga Khan University Hospital": "AKUH",
    "Shifa Tameer-e-Millat University": "STMU",
    "Karakoram International University": "KIU",
    "Kohat University of Science and Technology": "KUST",
    "Allama Iqbal Open University": "AIOU",
    "Riphah International University": "RIU",
    "International Islamic University": "IIUI",
    "Abdul Wali Khan University Mardan": "AWKUM",
    "Hazara University": "HU",
    "Sukkur IBA University": "SIBAU",
    "Sindh Agriculture University": "SAU",
    "Sindh Madressatul Islam University": "SMIU",
    "Lahore College for Women University": "LCWU",
    "Fatima Jinnah Women University": "FJWU",
    "Islamia College University": "ICU",
    "Islamia University of Bahawalpur": "IUB",
    "Federal Urdu University of Arts, Sciences and Technology": "FUUAST",
    "Shah Abdul Latif University": "SALU",
    "Pir Mehr Ali Shah Arid Agriculture University": "PMAS-AAUR",
    "National Textile University": "NTU",
    "National College of Arts": "NCA",
    "National Defence University": "NDU",
    "Pakistan Institute of Development Economics": "PIDE",
    "Pakistan Institute of Fashion and Design": "PIFD",
    "Pakistan Institute of Medical Sciences": "PIMS",
    "HITEC University": "HITEC",
    "Capital University of Science and Technology": "CUST",
    "CECOS University of Information Technology and Emerging Sciences": "CECOS",
    "Institute of Cost and Management Accountants of Pakistan": "ICMAP",
    "Mirpur University of Science and Technology": "MUST",
    "Shaheed Benazir Bhutto University Sheringal": "SBBU Sheringal",
    "Shaheed Benazir Bhutto University": "SBBU",
    "Shaheed Benazir Bhutto Women University": "SBBWU",
    "Shaheed Benazir Bhutto University of Veterinary and Animal Sciences": "SBBUVAS",
    "Shaheed Mohtarma Benazir Bhutto Medical University": "SMBBMU",
    "Sardar Bahadur Khan Women University": "SBKWU",
    "Balochistan University of Information Technology, Engineering and Management Sciences": "BUITEMS",
    "Balochistan University of Engineering and Technology": "BUET Khuzdar",
    "Khwaja Fareed University of Engineering and Information Technology": "KFUEIT",
    "Indus University": "IU",
    "Isra University": "ISRA",
    "Iqra University": "IQRA",
    "Iqra National University": "INU",
    "Abasyn University": "ABASYN",
    "Sarhad University of Science and Information Technology": "SUIT",
    "Qurtuba University of Science and Information Technology": "QURTUBA",
    "Preston University": "PRESTON",
    "Superior University": "SUPERIOR",
    "Hamdard University": "HAMDARD",
    "Forman Christian College": "FCCU",
    "Kinnaird College for Women": "KCW",
    "Habib University": "HU Karachi",
    "DHA Suffa University": "DSU",
    "Greenwich University": "GU",
    "Ziauddin University": "ZIU",
    "University of Education": "UE",
    "University of Health Sciences": "UHS",
    "University of Home Economics": "UHE",
    "University of Child Health Sciences": "UCHS",
    "University of Technology": "UoT Nowshera",
    "University of Women Mardan": "UWM",
    "Women University Swabi": "WUS",
    "Women University of Azad Jammu and Kashmir": "WUAJK",
    "Women University of Bagh": "WUB",
    "Nishtar Medical University": "NMU",
    "Faisalabad Medical University": "FMU",
    "Punjab Tianjin University of Technology": "PTUT",
    "National University of Technology": "NUTECH",
    "National University of Pakistan": "NUP",
    "National University of Sciences and Technology School of Civil and Environmental Engineering": "NUST SCEE",
    "Bahria University Medical and Dental College": "BUMDC",
    "Foundation University Medical College": "FUMC",
    "Army Medical College": "AMC",
    "Rawalpindi Medical College": "RMC",
    "Gujranwala Medical College": "GMC",
    "Sialkot Medical College": "SMC",
    "Bannu Medical College": "BMC",
    "Swat Medical College": "SMC Swat",
    "Gomal Medical College": "GMC D.I. Khan",
    "Peshawar Medical College": "PMC",
    "Frontier Medical College": "FMC",
    "Rehman College of Rehabilitation Sciences": "RCRS",
    "Women Medical College": "WMC",
    "Abbottabad International Medical College": "AIMC",
    "Independent Medical College": "IMC",
    "Central Park Medical College": "CPMC",
    "Rashid Latif Medical College": "RLMC",
    "FMH College of Medicine and Dentistry": "FMH",
    "Lahore Medical and Dental College": "LMDC",
    "Sharif Medical and Dental College": "SMDC",
    "Sahara Medical College": "SAHARA",
    "Bashir Institute of Health Sciences": "BIHS",
    "Shifa College of Medicine": "SCM",
    "Gandhara University": "GANDHARA",
    "Ilma University": "ILMA",
    "Lahore School of Economics": "LSE",
    "National College of Business Administration & Economics": "NCBA&E",
    "Nazeer Hussain University": "NHU",
    "Baba Guru Nanak University": "BGNU",
    "Cholistan University of Veterinary and Animal Sciences": "CUVAS",
    "Ghazi University": "GU D.G. Khan",
    "Emerson University Multan": "EUM",
    "University of Baltistan": "UoB Skardu",
    "FATA University": "FATAU",
    "Bolan University of Medical and Health Sciences": "BUMHS",
    "Institute of Business and Technology": "IBT",
    "Sir Syed CASE Institute of Technology": "SSCIT",
    "Pak-Austria Fachhochschule Institute of Applied Sciences and Technology": "PAF-IAST",
    "Begum Nusrat Bhutto Women University": "BNBWU",
    "Shaikh Ayaz University": "SAU Shikarpur",
    "Government Sadiq College Women University": "GSCWU",
    "Government College Women University Faisalabad": "GCWUF",
    "Government College Women University Sialkot": "GCWUS",
    "Government College Women University": "GCWU",
    "University of Sufism and Modern Sciences": "USMS",
    "University of Shangla": "UoSh",
    "University of Turbat": "UoT",
    "University of Loralai": "UoL",
    "University of Makran": "UoM",
    "University of Zhob": "UoZ",
    "University of Chenab": "UOC",
    "University of Chitral": "UoCh",
    "University of Neelum": "UoN",
    "Rawal Institute of Health Sciences": "RIHS",
    "Yusra Institute of Pharmaceutical Sciences": "YIPS",
    "Margalla Institute of Health Sciences": "MIHS",
    "Islamabad Medical and Dental College": "IMDC",
    "Shalamar Medical and Dental College": "SMDC Lahore",
    "Akhtar Saeed Medical and Dental College": "ASMDC",
    "Azra Naheed Medical College": "ANMC",
    "CMH Lahore Medical College and Institute of Dentistry": "CMH LMC",
    "Wah Medical College": "WMC Wah",
    "Fazaia Medical College": "FMC Islamabad",
    "Quetta Institute of Medical Sciences": "QIMS",
    "Lahore University of Biological and Applied Sciences": "LUBAS",
    "Pakistan Institute of Community Ophthalmology": "PICO",
    "Northwest School of Medicine": "NWSM",
    "Kabir Medical College": "KMC",
    "Multan Medical and Dental College": "MMDC",
    "Bakhtawar Amin Medical and Dental College": "BAMDC",
    "Aziz Fatimah Medical and Dental College": "AFMDC",
    "Continental Medical College": "CMC",
    "Islam Medical College": "Islam MC",
    "M. Islam Medical College": "MIMC",
    "Azad Jammu and Kashmir Medical College": "AJKMC",
    "Mohtarma Benazir Bhutto Shaheed Medical College": "MBBSMC",
    "Poonch Medical College": "PooMC",
    "Sughra Shafi Medical Complex": "SSMC",
    "Health Services Academy": "HSA",
    "Al-Kawthar University": "AKU Karachi",
    "Al-Hamd Islamic University": "AIU",
    "Benazir Bhutto Shaheed University": "BBSYDP",
    "Benazir Bhutto Shaheed University of Technology and Skill Development": "BBSUTSD",
    "City University of Science and Information Technology": "CUSIT",
    "Foundation University": "FUI",
    "GIFT University": "GIFT",
    "Gomal University": "GU",
    "Hajvery University": "HU Lahore",
    "Karachi Institute of Economics and Technology": "KIET",
    "Lahore Garrison University": "LGU",
    "Lahore Leads University": "LLU",
    "Lasbela University of Agriculture, Water and Marine Sciences": "LUAWMS",
    "Minhaj University": "MUL",
    "Mohi-ud-Din Islamic University": "MIU",
    "Multan University of Science and Technology": "MUST Multan",
    "Mirpur University of Science and Technology": "MUST AJK",
    "Qarshi University": "QU",
    "University of Chakwal": "UOC",
    "University of Gujrat": "UOG",
    "University of Haripur": "UOH",
    "University of Jhang": "UOJ",
    "University of Layyah": "UOLY",
    "University of Malakand": "UOM",
    "University of Mianwali": "UOMW",
    "University of Narowal": "UON",
    "University of Okara": "UOO",
    "University of Poonch": "UOP",
    "University of Sialkot": "UOS",
    "University of Swabi": "UOSW",
    "University of Swat": "UOSw",
    "University of Wah": "UOW",
    "University of Sahiwal": "UOSah",
    "University of Dera Ghazi Khan": "UODGK",
    "University of Mirpurkhas": "UOMir",
    "University of Larkano": "UOLar",
    "University of Gwadar": "UOGw",
    "University of Azad Jammu and Kashmir": "UAJK",
    "University of Kotli Azad Jammu and Kashmir": "UKAJK",
    "Institute of Business Administration": "IBA",
    "Preston Institute of Management Sciences and Technology": "PIMSAT",
    "Abasyn University": "ABASYN",
    "The University of Faisalabad": "TUF",
    "University of Faisalabad": "UOF",
    "University of Education": "UE",
}

# Merge duplicate institutions into one canonical record.
_alias(
    "FAST National University of Computer and Emerging Sciences",
    "National University of Computer and Emerging Sciences",
    "FAST National University",
    "FAST NU",
    "NUCES",
    "FAST-NUCES",
)
_alias(
    "Shaheed Zulfiqar Ali Bhutto Institute of Science and Technology",
    "Shaheed Zulfiqar Ali Bhutto Institute of Science and Technology (SZABIST)",
    "SZABIST",
)
_alias("School of Civil and Environmental Engineering", "NUST SCEE")
_alias("University of Poonch", "University of Poonch Rawalakot")
_alias("Mirpur University of Science and Technology", "Mirpur University of Science and Technology (MUST)")
_alias("The University of Faisalabad", "University of Faisalabad")

# Entries that are not chartered universities, or that we could not corroborate.
# Held back from public listings but preserved for admin review.
NOT_UNIVERSITY = {
    _norm("Islamabad Model College for Girls"),
}

UNVERIFIED_HOLD = {
    _norm("University of Rawalpindi"),
    _norm("University of Taxila"),
    _norm("University of Hafizabad"),
    _norm("University of Kamalia"),
    _norm("University of Murree"),
    _norm("University of Rajanpur"),
    _norm("University of Taunsa"),
    _norm("University of Bhakkar"),
    _norm("University of Pakpattan"),
    _norm("University of Khanewal"),
    _norm("University of Kasur"),
    _norm("University of Sheikhupura"),
    _norm("University of Jhelum"),
    _norm("University of Kharian"),
    _norm("University of Bahawalnagar"),
    _norm("University of Rahim Yar Khan"),
    _norm("University of Muzaffargarh"),
    _norm("University of Vehari"),
    _norm("University of Lodhran"),
    _norm("University of Attock"),
}

# --------------------------------------------------------------------------
# 3. Parsing
# --------------------------------------------------------------------------
CAMPUS_SUFFIX = re.compile(r"^(.*?)\s+[-–]\s+(.+?)\s*$")


def find_city(text: str) -> str | None:
    """Return the longest known city mentioned in `text`."""
    haystack = text.lower()
    best = None
    for city in CITY_PROVINCE:
        if city in haystack and (best is None or len(city) > len(best)):
            best = city
    if not best:
        return None
    titled = best.title()
    return CITY_DISPLAY.get(titled, titled)


CITY_DISPLAY = {
    "Rahimyar khan": "Rahim Yar Khan",
    "Rahim yar khan": "Rahim Yar Khan",
    "D.g. khan": "Dera Ghazi Khan",
    "D.i. khan": "Dera Ismail Khan",
    "Khairpur mirs": "Khairpur Mirs",
    "Wah cantt": "Wah Cantt",
    "Wah": "Wah Cantt",
    "Mirpur khas": "Mirpur Khas",
    "Larkano": "Larkana",
    "Shaheed benazirabad": "Shaheed Benazirabad",
    "Nawabshah": "Shaheed Benazirabad",
    "Nerian sharif": "Nerian Sharif",
    "Chak shahzad": "Islamabad",
    "Gulberg greens": "Islamabad",
    "Islamabad capital territory": "Islamabad",
    "Ict": "Islamabad",
    "Ahsanabad": "Karachi",
    "Lyari": "Karachi",
    "North karachi": "Karachi",
    "Gulshan": "Karachi",
    "Kala shah kaku": "Kala Shah Kaku",
    "Mithi": "Mithi",
    "Tharparkar": "Mithi",
}

# Campus row without an explicit city in its name -> resolve from institution.
CAMPUS_CITY_OVERRIDES = {
    "north campus": "Karachi",
    "dha city campus": "Karachi",
    "ojha campus": "Karachi",
    "main campus": None,
    "chak shahzad campus islamabad": "Islamabad",
    "gulshan campus karachi": "Karachi",
    "north campus karachi": "Karachi",
    "islamabad school of management sciences": "Islamabad",
    "rachna college gujranwala": "Gujranwala",
    "nilore campus": "Islamabad",
    "nerian sharif campus": "Nerian Sharif",
    "kala shah kaku campus": "Kala Shah Kaku",
    "gulberg greens campus": "Islamabad",
}

INSTITUTIONS: dict[str, dict] = {}
CAMPUS_SEEN: set[tuple[str, str]] = set()
REVIEW: list[dict] = []


def canonical_name(raw: str) -> str:
    n = _norm(raw)
    return ALIAS_TO_CANONICAL.get(n, raw.strip())


def ensure_institution(raw: str) -> dict:
    name = canonical_name(raw)
    key = _norm(name)
    if key not in INSTITUTIONS:
        INSTITUTIONS[key] = {
            "name": name,
            "slug": slugify(name),
            "abbreviation": ABBREVIATIONS.get(name),
            "aliases": sorted({name} | {a for a, c in ALIAS_TO_CANONICAL.items() if c == name and a != key}),
            "campuses": [],
        }
    return INSTITUTIONS[key]


def add_campus(inst: dict, campus_name: str, city: str | None, province: str | None, source: str) -> None:
    campus_name = (campus_name or "Main Campus").strip()
    campus_name = re.sub(r"\s+", " ", campus_name)
    if campus_name.lower().endswith(" campus"):
        pass  # keep the word "Campus" for readability in the UI
    key = (_norm(inst["name"]), _norm(campus_name))
    if key in CAMPUS_SEEN:
        return
    CAMPUS_SEEN.add(key)
    inst["campuses"].append(
        {
            "name": campus_name,
            "slug": slugify(f"{inst['name']}-{campus_name}"),
            "city": city,
            "province": province,
            "source_line": source,
        }
    )


def process_line(line: str) -> None:
    raw = line.strip()
    if not raw:
        return

    n = _norm(raw)
    if n in NOT_UNIVERSITY:
        REVIEW.append({"source": raw, "reason": "not_a_university"})
        return

    inst_part, campus_part = raw, None
    m = CAMPUS_SUFFIX.match(raw)
    if m:
        inst_part, campus_part = m.group(1), m.group(2)
    elif "," in raw:
        head, tail = raw.rsplit(",", 1)
        tail = tail.strip()
        # ", Lahore" style city suffix - only treat as campus if it looks like one
        if tail.lower().endswith("campus") or find_city(tail) or tail in ("Wah Cantt",):
            inst_part, campus_part = head, tail
        elif _norm(head) in {_norm(k) for k in ABBREVIATIONS} or len(tail.split()) <= 3:
            inst_part, campus_part = head, tail

    if _norm(inst_part) in NOT_UNIVERSITY:
        REVIEW.append({"source": raw, "reason": "not_a_university"})
        return

    inst = ensure_institution(inst_part)

    if campus_part:
        campus_name = campus_part if campus_part.lower().endswith("campus") else f"{campus_part}"
        city = find_city(campus_part) or find_city(inst["name"])
        if campus_name.lower() in CAMPUS_CITY_OVERRIDES:
            city = CAMPUS_CITY_OVERRIDES[campus_name.lower()] or city
        if not city and campus_name.lower() == "main campus":
            city = find_city(inst["name"])
        province = CITY_PROVINCE.get((city or "").lower())
        add_campus(inst, campus_name, city, province, raw)
    else:
        # Bare institution with no campus info -> synthesise a Main Campus.
        city = find_city(inst["name"])
        province = CITY_PROVINCE.get((city or "").lower())
        if not city:
            # try the well-known home city for a handful of institutions
            guess = HOME_CITY.get(_norm(inst["name"]))
            city = guess
            province = CITY_PROVINCE.get((guess or "").lower()) if guess else None
        add_campus(inst, "Main Campus", city, province, raw)


HOME_CITY = {
    _norm("Abdul Wali Khan University Mardan"): "Mardan",
    _norm("Abbottabad University of Science and Technology"): "Abbottabad",
    _norm("Allama Iqbal Open University"): "Islamabad",
    _norm("Baba Guru Nanak University"): "Nankana Sahib",
    _norm("Cholistan University of Veterinary and Animal Sciences"): "Bahawalpur",
    _norm("Emerson University Multan"): "Multan",
    _norm("FATA University"): "Kohat",
    _norm("Gandhara University"): "Peshawar",
    _norm("Ghazi University"): "Dera Ghazi Khan",
    _norm("Ghulam Ishaq Khan Institute of Engineering Sciences and Technology"): "Swabi",
    _norm("Government College Women University Faisalabad"): "Faisalabad",
    _norm("Government College Women University Sialkot"): "Sialkot",
    _norm("Government Sadiq College Women University"): "Bahawalpur",
    _norm("Fatima Jinnah Medical University"): "Lahore",
    _norm("Rawalpindi Medical University"): "Rawalpindi",
    _norm("University of Baltistan"): "Skardu",
    _norm("Women University Swabi"): "Swabi",
    _norm("University of Buner"): "Buner",
    _norm("University of Lakki Marwat"): "Lakki Marwat",
    _norm("Government College University Hyderabad"): "Hyderabad",
    _norm("University of Mirpurkhas"): "Mirpur Khas",
    _norm("University of Larkano"): "Larkana",
    _norm("Pakistan Marine Academy"): "Karachi",
    _norm("Ibadat International University"): "Islamabad",
    _norm("Ilma University"): "Karachi",
    _norm("National College of Business Administration & Economics"): "Lahore",
    _norm("Nazeer Hussain University"): "Karachi",
    _norm("Lahore School of Economics"): "Lahore",
    _norm("Institute of Cost and Management Accountants of Pakistan"): "Karachi",
    _norm("Institute of Business and Technology"): "Karachi",
    _norm("Preston Institute of Management Sciences and Technology"): "Karachi",
    _norm("HITEC University"): "Taxila",
    _norm("Pak-Austria Fachhochschule Institute of Applied Sciences and Technology"): "Haripur",
    _norm("Ghulam Ishaq Khan Institute of Engineering Sciences and Technology"): "Swabi",
    _norm("Sir Syed CASE Institute of Technology"): "Islamabad",
    _norm("National University of Medical Sciences"): "Rawalpindi",
    _norm("Shaheed Mohtarma Benazir Bhutto Medical University"): "Larkana",
    _norm("Bolan University of Medical and Health Sciences"): "Quetta",
    _norm("Jinnah Sindh Medical University"): "Karachi",
    _norm("Liaquat University of Medical and Health Sciences"): "Jamshoro",
    _norm("People's University of Medical and Health Sciences for Women"): "Nawabshah",
    _norm("Sindh Institute of Medical Sciences"): "Karachi",
    _norm("National University of Pakistan"): "Islamabad",
    _norm("National University of Technology"): "Islamabad",
    _norm("University of Azad Jammu and Kashmir"): "Muzaffarabad",
    _norm("University of Kotli Azad Jammu and Kashmir"): "Kotli",
    _norm("Women University of Azad Jammu and Kashmir"): "Bagh",
    _norm("University of Sahiwal"): "Sahiwal",
    _norm("University of Loralai"): "Loralai",
    _norm("University of Gwadar"): "Gwadar",
    _norm("University of Makran"): "Panjgur",
    _norm("University of Zhob"): "Zhob",
    _norm("University of Dera Ghazi Khan"): "Dera Ghazi Khan",
    _norm("University of Chakwal"): "Chakwal",
    _norm("University of Chenab"): "Gujrat",
    _norm("University of Chitral"): "Chitral",
    _norm("University of Haripur"): "Haripur",
    _norm("University of Home Economics"): "Lahore",
    _norm("University of Layyah"): "Layyah",
    _norm("University of Neelum"): "Athmuqam",
    _norm("University of Okara"): "Okara",
    _norm("University of Shangla"): "Shangla",
    _norm("University of Sialkot"): "Sialkot",
    _norm("University of Swabi"): "Swabi",
    _norm("University of Swat"): "Mingora",
    _norm("University of Turbat"): "Turbat",
    _norm("University of Wah"): "Wah Cantt",
    _norm("University of Jhang"): "Jhang",
    _norm("University of Malakand"): "Batkhela",
    _norm("University of Mianwali"): "Mianwali",
    _norm("University of Narowal"): "Narowal",
    _norm("University of Sargodha"): "Sargodha",
    _norm("University of Gujrat"): "Gujrat",
    _norm("University of Technology"): "Nowshera",
    _norm("University of Education"): "Lahore",
    _norm("University of Health Sciences"): "Lahore",
    _norm("University of Home Economics"): "Lahore",
    _norm("University of Child Health Sciences"): "Lahore",
    _norm("University of Women Mardan"): "Mardan",
    _norm("National University of Sciences and Technology School of Civil and Environmental Engineering"): "Islamabad",
    _norm("Balochistan University of Engineering and Technology"): "Khuzdar",
    _norm("Shaikh Ayaz University"): "Shikarpur",
    _norm("University of Sufism and Modern Sciences"): "Bhitshah",
    _norm("Government College Women University"): "Bahawalpur",
    _norm("Pakistan Institute of Community Ophthalmology"): "Peshawar",
    _norm("Rawal Institute of Health Sciences"): "Islamabad",
    _norm("Yusra Institute of Pharmaceutical Sciences"): "Islamabad",
    _norm("Margalla Institute of Health Sciences"): "Rawalpindi",
    _norm("Wah Medical College"): "Wah Cantt",
    _norm("Fazaia Medical College"): "Islamabad",
    _norm("Quetta Institute of Medical Sciences"): "Quetta",
    _norm("Lahore University of Biological and Applied Sciences"): "Lahore",
    _norm("Health Services Academy"): "Islamabad",
    _norm("Pakistan Marine Academy"): "Karachi",
}

# Manual post-processing: name/alias tidy-ups
DISPLAY_NAME_FIX = {
    "University of the Punjab": "University of the Punjab",
    "Quaid-i-Awam University of Engineering, Science and Technology": "Quaid-i-Awam University of Engineering, Science and Technology",
}

PROVINCE_OF_HOME_CITY = {c: p for c, p in CITY_PROVINCE.items()}


def main() -> None:
    for line in SRC.read_text(encoding="utf-8").splitlines():
        process_line(line)

    # Reinstate the source's explicit "University of the Punjab" style entry
    for raw in ["University of the Punjab"]:
        pass

    records = []
    for key, inst in INSTITUTIONS.items():
        primary = inst["campuses"][0] if inst["campuses"] else None
        status = "pending_review" if key in UNVERIFIED_HOLD else "active"
        if not inst["campuses"]:
            status = "pending_review"
        records.append(
            {
                "name": DISPLAY_NAME_FIX.get(inst["name"], inst["name"]),
                "slug": inst["slug"],
                "abbreviation": inst["abbreviation"],
                "aliases": inst["aliases"],
                "city": primary["city"] if primary else None,
                "province": primary["province"] if primary else None,
                "status": status,
                "is_active": status == "active",
                "campuses": inst["campuses"],
            }
        )

    records.sort(key=lambda r: r["name"].lower())

    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "universities.json").write_text(json.dumps(records, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    with (OUT / "campuses.csv").open("w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh)
        w.writerow(["university", "abbreviation", "campus", "city", "province", "status"])
        for r in records:
            for c in r["campuses"]:
                w.writerow([r["name"], r["abbreviation"] or "", c["name"], c["city"] or "", c["province"] or "", r["status"]])

    with (OUT / "review.csv").open("w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh)
        w.writerow(["reason", "source_line"])
        for row in REVIEW:
            w.writerow([row["reason"], row["source"]])
        for r in records:
            if r["status"] == "pending_review":
                w.writerow(["unverified_or_no_campus", r["name"]])

    campus_count = sum(len(r["campuses"]) for r in records)
    held = sum(1 for r in records if r["status"] != "active")
    print(f"institutions : {len(records)}")
    print(f"campuses     : {campus_count}")
    print(f"pending      : {held}")
    print(f"review.csv   : {len(REVIEW)} excluded lines")
    missing = [r["name"] for r in records if not r["city"] and r["status"] == "active"]
    if missing:
        print(f"WARN active institutions without a city: {len(missing)}")
        for m in missing[:20]:
            print("   -", m)


if __name__ == "__main__":
    main()
