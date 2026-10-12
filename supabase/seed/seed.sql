-- =============================================================================
-- Campusly · GENERATED FILE — do not edit by hand.
-- Regenerate with: npm run seed:build
-- Source: 264 institutions, 437 campuses
-- =============================================================================

begin;

-- 1. Institutions ------------------------------------------------------------
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Abasyn University',
  lower(regexp_replace('Abasyn University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'abasyn-university',
  'ABASYN',
  array['Abasyn University']::text[],
  'Abasyn University (ABASYN) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Abbottabad International Medical College',
  lower(regexp_replace('Abbottabad International Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'abbottabad-international-medical-college',
  'AIMC',
  array['Abbottabad International Medical College']::text[],
  'Abbottabad International Medical College (AIMC) is located in Abbottabad, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Abbottabad',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Abbottabad University of Science and Technology',
  lower(regexp_replace('Abbottabad University of Science and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'abbottabad-university-of-science-and-technology',
  null,
  array['Abbottabad University of Science and Technology']::text[],
  'Abbottabad University of Science and Technology is an engineering and applied-sciences institution in Abbottabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Abbottabad',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Abdul Wali Khan University Mardan',
  lower(regexp_replace('Abdul Wali Khan University Mardan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'abdul-wali-khan-university-mardan',
  'AWKUM',
  array['Abdul Wali Khan University Mardan']::text[],
  'Abdul Wali Khan University Mardan (AWKUM) is located in Mardan, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Mardan',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Aga Khan University',
  lower(regexp_replace('Aga Khan University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'aga-khan-university',
  'AKU',
  array['Aga Khan University']::text[],
  'Aga Khan University (AKU) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Air University',
  lower(regexp_replace('Air University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'air-university',
  'AU',
  array['Air University']::text[],
  'Air University (AU) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Akhtar Saeed Medical and Dental College',
  lower(regexp_replace('Akhtar Saeed Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'akhtar-saeed-medical-and-dental-college',
  'ASMDC',
  array['Akhtar Saeed Medical and Dental College']::text[],
  'Akhtar Saeed Medical and Dental College (ASMDC) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Al-Hamd Islamic University',
  lower(regexp_replace('Al-Hamd Islamic University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'al-hamd-islamic-university',
  'AIU',
  array['Al-Hamd Islamic University']::text[],
  'Al-Hamd Islamic University (AIU) is located in Quetta, Balochistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Quetta',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Al-Kawthar University',
  lower(regexp_replace('Al-Kawthar University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'al-kawthar-university',
  'AKU Karachi',
  array['Al-Kawthar University']::text[],
  'Al-Kawthar University (AKU Karachi) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Allama Iqbal Open University',
  lower(regexp_replace('Allama Iqbal Open University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'allama-iqbal-open-university',
  'AIOU',
  array['Allama Iqbal Open University']::text[],
  'Allama Iqbal Open University (AIOU) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Army Medical College',
  lower(regexp_replace('Army Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'army-medical-college',
  'AMC',
  array['Army Medical College']::text[],
  'Army Medical College (AMC) is located in Rawalpindi, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalpindi',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Azad Jammu and Kashmir Medical College',
  lower(regexp_replace('Azad Jammu and Kashmir Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'azad-jammu-and-kashmir-medical-college',
  'AJKMC',
  array['Azad Jammu and Kashmir Medical College']::text[],
  'Azad Jammu and Kashmir Medical College (AJKMC) is located in Muzaffarabad, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Muzaffarabad',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Aziz Fatimah Medical and Dental College',
  lower(regexp_replace('Aziz Fatimah Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'aziz-fatimah-medical-and-dental-college',
  'AFMDC',
  array['Aziz Fatimah Medical and Dental College']::text[],
  'Aziz Fatimah Medical and Dental College (AFMDC) is located in Faisalabad, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Faisalabad',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Azra Naheed Medical College',
  lower(regexp_replace('Azra Naheed Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'azra-naheed-medical-college',
  'ANMC',
  array['Azra Naheed Medical College']::text[],
  'Azra Naheed Medical College (ANMC) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Baba Guru Nanak University',
  lower(regexp_replace('Baba Guru Nanak University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'baba-guru-nanak-university',
  'BGNU',
  array['Baba Guru Nanak University']::text[],
  'Baba Guru Nanak University (BGNU) is located in Nankana Sahib, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Nankana Sahib',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Bahauddin Zakariya University',
  lower(regexp_replace('Bahauddin Zakariya University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'bahauddin-zakariya-university',
  'BZU',
  array['Bahauddin Zakariya University']::text[],
  'Bahauddin Zakariya University (BZU) is located in Multan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Multan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Bahria University',
  lower(regexp_replace('Bahria University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'bahria-university',
  'BU',
  array['Bahria University']::text[],
  'Bahria University (BU) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Bahria University Medical and Dental College',
  lower(regexp_replace('Bahria University Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'bahria-university-medical-and-dental-college',
  'BUMDC',
  array['Bahria University Medical and Dental College']::text[],
  'Bahria University Medical and Dental College (BUMDC) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Bakhtawar Amin Medical and Dental College',
  lower(regexp_replace('Bakhtawar Amin Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'bakhtawar-amin-medical-and-dental-college',
  'BAMDC',
  array['Bakhtawar Amin Medical and Dental College']::text[],
  'Bakhtawar Amin Medical and Dental College (BAMDC) is located in Multan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Multan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Balochistan University of Engineering and Technology',
  lower(regexp_replace('Balochistan University of Engineering and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'balochistan-university-of-engineering-and-technology',
  'BUET Khuzdar',
  array['Balochistan University of Engineering and Technology']::text[],
  'Balochistan University of Engineering and Technology (BUET Khuzdar) is an engineering and applied-sciences institution in Khuzdar. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Khuzdar',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Balochistan University of Information Technology, Engineering and Management Sciences',
  lower(regexp_replace('Balochistan University of Information Technology, Engineering and Management Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'balochistan-university-of-information-technology-engineering-and-management-sciences',
  'BUITEMS',
  array['Balochistan University of Information Technology, Engineering and Management Sciences']::text[],
  'Balochistan University of Information Technology, Engineering and Management Sciences (BUITEMS) is an engineering and applied-sciences institution in Quetta. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Quetta',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Bannu Medical College',
  lower(regexp_replace('Bannu Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'bannu-medical-college',
  'BMC',
  array['Bannu Medical College']::text[],
  'Bannu Medical College (BMC) is located in Bannu, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Bannu',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Bashir Institute of Health Sciences',
  lower(regexp_replace('Bashir Institute of Health Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'bashir-institute-of-health-sciences',
  'BIHS',
  array['Bashir Institute of Health Sciences']::text[],
  'Bashir Institute of Health Sciences (BIHS) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Begum Nusrat Bhutto Women University',
  lower(regexp_replace('Begum Nusrat Bhutto Women University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'begum-nusrat-bhutto-women-university',
  'BNBWU',
  array['Begum Nusrat Bhutto Women University']::text[],
  'Begum Nusrat Bhutto Women University (BNBWU) is located in Sukkur, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sukkur',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Benazir Bhutto Shaheed University',
  lower(regexp_replace('Benazir Bhutto Shaheed University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'benazir-bhutto-shaheed-university',
  'BBSYDP',
  array['Benazir Bhutto Shaheed University']::text[],
  'Benazir Bhutto Shaheed University (BBSYDP) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Benazir Bhutto Shaheed University of Technology and Skill Development',
  lower(regexp_replace('Benazir Bhutto Shaheed University of Technology and Skill Development', '[^a-zA-Z0-9]+', ' ', 'g')),
  'benazir-bhutto-shaheed-university-of-technology-and-skill-development',
  'BBSUTSD',
  array['Benazir Bhutto Shaheed University of Technology and Skill Development']::text[],
  'Benazir Bhutto Shaheed University of Technology and Skill Development (BBSUTSD) is an engineering and applied-sciences institution in Khairpur Mirs. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Khairpur Mirs',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Bolan University of Medical and Health Sciences',
  lower(regexp_replace('Bolan University of Medical and Health Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'bolan-university-of-medical-and-health-sciences',
  'BUMHS',
  array['Bolan University of Medical and Health Sciences']::text[],
  'Bolan University of Medical and Health Sciences (BUMHS) is an engineering and applied-sciences institution in Bolan. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Bolan',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Capital University of Science and Technology',
  lower(regexp_replace('Capital University of Science and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'capital-university-of-science-and-technology',
  'CUST',
  array['Capital University of Science and Technology']::text[],
  'Capital University of Science and Technology (CUST) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'CECOS University of Information Technology and Emerging Sciences',
  lower(regexp_replace('CECOS University of Information Technology and Emerging Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'cecos-university-of-information-technology-and-emerging-sciences',
  'CECOS',
  array['CECOS University of Information Technology and Emerging Sciences']::text[],
  'CECOS University of Information Technology and Emerging Sciences (CECOS) is an engineering and applied-sciences institution in Peshawar. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Central Park Medical College',
  lower(regexp_replace('Central Park Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'central-park-medical-college',
  'CPMC',
  array['Central Park Medical College']::text[],
  'Central Park Medical College (CPMC) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Cholistan University of Veterinary and Animal Sciences',
  lower(regexp_replace('Cholistan University of Veterinary and Animal Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'cholistan-university-of-veterinary-and-animal-sciences',
  'CUVAS',
  array['Cholistan University of Veterinary and Animal Sciences']::text[],
  'Cholistan University of Veterinary and Animal Sciences (CUVAS) is an engineering and applied-sciences institution in Bahawalpur. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Bahawalpur',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'City University of Science and Information Technology',
  lower(regexp_replace('City University of Science and Information Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'city-university-of-science-and-information-technology',
  'CUSIT',
  array['City University of Science and Information Technology']::text[],
  'City University of Science and Information Technology (CUSIT) is an engineering and applied-sciences institution in Peshawar. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'CMH Lahore Medical College and Institute of Dentistry',
  lower(regexp_replace('CMH Lahore Medical College and Institute of Dentistry', '[^a-zA-Z0-9]+', ' ', 'g')),
  'cmh-lahore-medical-college-and-institute-of-dentistry',
  'CMH LMC',
  array['CMH Lahore Medical College and Institute of Dentistry']::text[],
  'CMH Lahore Medical College and Institute of Dentistry (CMH LMC) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'COMSATS University Islamabad',
  lower(regexp_replace('COMSATS University Islamabad', '[^a-zA-Z0-9]+', ' ', 'g')),
  'comsats-university-islamabad',
  'CUI',
  array['COMSATS University Islamabad']::text[],
  'COMSATS University Islamabad (CUI) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Continental Medical College',
  lower(regexp_replace('Continental Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'continental-medical-college',
  'CMC',
  array['Continental Medical College']::text[],
  'Continental Medical College (CMC) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Dawood University of Engineering and Technology',
  lower(regexp_replace('Dawood University of Engineering and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'dawood-university-of-engineering-and-technology',
  'DUET',
  array['Dawood University of Engineering and Technology']::text[],
  'Dawood University of Engineering and Technology (DUET) is an engineering and applied-sciences institution in Karachi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'DHA Suffa University',
  lower(regexp_replace('DHA Suffa University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'dha-suffa-university',
  'DSU',
  array['DHA Suffa University']::text[],
  'DHA Suffa University (DSU) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Dow University of Health Sciences',
  lower(regexp_replace('Dow University of Health Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'dow-university-of-health-sciences',
  'DUHS',
  array['Dow University of Health Sciences']::text[],
  'Dow University of Health Sciences (DUHS) is an engineering and applied-sciences institution in Karachi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Emerson University Multan',
  lower(regexp_replace('Emerson University Multan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'emerson-university-multan',
  'EUM',
  array['Emerson University Multan']::text[],
  'Emerson University Multan (EUM) is located in Multan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Multan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Faisalabad Medical University',
  lower(regexp_replace('Faisalabad Medical University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'faisalabad-medical-university',
  'FMU',
  array['Faisalabad Medical University']::text[],
  'Faisalabad Medical University (FMU) is located in Faisalabad, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Faisalabad',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'FAST National University of Computer and Emerging Sciences',
  lower(regexp_replace('FAST National University of Computer and Emerging Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'fast-national-university-of-computer-and-emerging-sciences',
  'FAST-NUCES',
  array['FAST National University of Computer and Emerging Sciences', 'fast national university', 'fast nu', 'fast nuces', 'national university of computer and emerging sciences', 'nuces']::text[],
  'FAST National University of Computer and Emerging Sciences (FAST-NUCES) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'FATA University',
  lower(regexp_replace('FATA University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'fata-university',
  'FATAU',
  array['FATA University']::text[],
  'FATA University (FATAU) is located in Kohat, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Kohat',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Fatima Jinnah Medical University',
  lower(regexp_replace('Fatima Jinnah Medical University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'fatima-jinnah-medical-university',
  'FJMU',
  array['Fatima Jinnah Medical University']::text[],
  'Fatima Jinnah Medical University (FJMU) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Fatima Jinnah Women University',
  lower(regexp_replace('Fatima Jinnah Women University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'fatima-jinnah-women-university',
  'FJWU',
  array['Fatima Jinnah Women University']::text[],
  'Fatima Jinnah Women University (FJWU) is located in Rawalpindi, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalpindi',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Fazaia Medical College',
  lower(regexp_replace('Fazaia Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'fazaia-medical-college',
  'FMC Islamabad',
  array['Fazaia Medical College']::text[],
  'Fazaia Medical College (FMC Islamabad) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Federal Urdu University of Arts, Sciences and Technology',
  lower(regexp_replace('Federal Urdu University of Arts, Sciences and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'federal-urdu-university-of-arts-sciences-and-technology',
  'FUUAST',
  array['Federal Urdu University of Arts, Sciences and Technology']::text[],
  'Federal Urdu University of Arts, Sciences and Technology (FUUAST) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'FMH College of Medicine and Dentistry',
  lower(regexp_replace('FMH College of Medicine and Dentistry', '[^a-zA-Z0-9]+', ' ', 'g')),
  'fmh-college-of-medicine-and-dentistry',
  'FMH',
  array['FMH College of Medicine and Dentistry']::text[],
  'FMH College of Medicine and Dentistry (FMH) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Forman Christian College',
  lower(regexp_replace('Forman Christian College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'forman-christian-college',
  'FCCU',
  array['Forman Christian College']::text[],
  'Forman Christian College (FCCU) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Foundation University',
  lower(regexp_replace('Foundation University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'foundation-university',
  'FUI',
  array['Foundation University']::text[],
  'Foundation University (FUI) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Foundation University Medical College',
  lower(regexp_replace('Foundation University Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'foundation-university-medical-college',
  'FUMC',
  array['Foundation University Medical College']::text[],
  'Foundation University Medical College (FUMC) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Frontier Medical College',
  lower(regexp_replace('Frontier Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'frontier-medical-college',
  'FMC',
  array['Frontier Medical College']::text[],
  'Frontier Medical College (FMC) is located in Abbottabad, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Abbottabad',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Gandhara University',
  lower(regexp_replace('Gandhara University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'gandhara-university',
  'GANDHARA',
  array['Gandhara University']::text[],
  'Gandhara University (GANDHARA) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Ghazi University',
  lower(regexp_replace('Ghazi University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'ghazi-university',
  'GU D.G. Khan',
  array['Ghazi University']::text[],
  'Ghazi University (GU D.G. Khan) is located in Dera Ghazi Khan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Dera Ghazi Khan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Ghulam Ishaq Khan Institute of Engineering Sciences and Technology',
  lower(regexp_replace('Ghulam Ishaq Khan Institute of Engineering Sciences and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'ghulam-ishaq-khan-institute-of-engineering-sciences-and-technology',
  'GIKI',
  array['Ghulam Ishaq Khan Institute of Engineering Sciences and Technology']::text[],
  'Ghulam Ishaq Khan Institute of Engineering Sciences and Technology (GIKI) is an engineering and applied-sciences institution in Swabi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Swabi',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'GIFT University',
  lower(regexp_replace('GIFT University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'gift-university',
  'GIFT',
  array['GIFT University']::text[],
  'GIFT University (GIFT) is located in Gujranwala, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Gujranwala',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Gomal Medical College',
  lower(regexp_replace('Gomal Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'gomal-medical-college',
  'GMC D.I. Khan',
  array['Gomal Medical College']::text[],
  'Gomal Medical College (GMC D.I. Khan) is located in Dera Ismail Khan, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Dera Ismail Khan',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Gomal University',
  lower(regexp_replace('Gomal University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'gomal-university',
  'GU',
  array['Gomal University']::text[],
  'Gomal University (GU) is located in Dera Ismail Khan, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Dera Ismail Khan',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Government College University',
  lower(regexp_replace('Government College University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'government-college-university',
  null,
  array['Government College University']::text[],
  'Government College University is located in Sialkot, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sialkot',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Government College University Faisalabad',
  lower(regexp_replace('Government College University Faisalabad', '[^a-zA-Z0-9]+', ' ', 'g')),
  'government-college-university-faisalabad',
  'GCUF',
  array['Government College University Faisalabad']::text[],
  'Government College University Faisalabad (GCUF) is located in Faisalabad, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Faisalabad',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Government College University Hyderabad',
  lower(regexp_replace('Government College University Hyderabad', '[^a-zA-Z0-9]+', ' ', 'g')),
  'government-college-university-hyderabad',
  'GCUH',
  array['Government College University Hyderabad']::text[],
  'Government College University Hyderabad (GCUH) is located in Hyderabad, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Hyderabad',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Government College University Lahore',
  lower(regexp_replace('Government College University Lahore', '[^a-zA-Z0-9]+', ' ', 'g')),
  'government-college-university-lahore',
  'GCU Lahore',
  array['Government College University Lahore']::text[],
  'Government College University Lahore (GCU Lahore) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Government College Women University',
  lower(regexp_replace('Government College Women University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'government-college-women-university',
  'GCWU',
  array['Government College Women University']::text[],
  'Government College Women University (GCWU) is located in Bahawalpur, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Bahawalpur',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Government College Women University Faisalabad',
  lower(regexp_replace('Government College Women University Faisalabad', '[^a-zA-Z0-9]+', ' ', 'g')),
  'government-college-women-university-faisalabad',
  'GCWUF',
  array['Government College Women University Faisalabad']::text[],
  'Government College Women University Faisalabad (GCWUF) is located in Faisalabad, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Faisalabad',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Government College Women University Sialkot',
  lower(regexp_replace('Government College Women University Sialkot', '[^a-zA-Z0-9]+', ' ', 'g')),
  'government-college-women-university-sialkot',
  'GCWUS',
  array['Government College Women University Sialkot']::text[],
  'Government College Women University Sialkot (GCWUS) is located in Sialkot, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sialkot',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Government Sadiq College Women University',
  lower(regexp_replace('Government Sadiq College Women University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'government-sadiq-college-women-university',
  'GSCWU',
  array['Government Sadiq College Women University']::text[],
  'Government Sadiq College Women University (GSCWU) is located in Bahawalpur, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Bahawalpur',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Greenwich University',
  lower(regexp_replace('Greenwich University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'greenwich-university',
  'GU',
  array['Greenwich University']::text[],
  'Greenwich University (GU) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Gujranwala Medical College',
  lower(regexp_replace('Gujranwala Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'gujranwala-medical-college',
  'GMC',
  array['Gujranwala Medical College']::text[],
  'Gujranwala Medical College (GMC) is located in Gujranwala, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Gujranwala',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Habib University',
  lower(regexp_replace('Habib University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'habib-university',
  'HU Karachi',
  array['Habib University']::text[],
  'Habib University (HU Karachi) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Hajvery University',
  lower(regexp_replace('Hajvery University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'hajvery-university',
  'HU Lahore',
  array['Hajvery University']::text[],
  'Hajvery University (HU Lahore) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Hamdard University',
  lower(regexp_replace('Hamdard University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'hamdard-university',
  'HAMDARD',
  array['Hamdard University']::text[],
  'Hamdard University (HAMDARD) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Hazara University',
  lower(regexp_replace('Hazara University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'hazara-university',
  'HU',
  array['Hazara University']::text[],
  'Hazara University (HU) is located in Mansehra, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Mansehra',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Health Services Academy',
  lower(regexp_replace('Health Services Academy', '[^a-zA-Z0-9]+', ' ', 'g')),
  'health-services-academy',
  'HSA',
  array['Health Services Academy']::text[],
  'Health Services Academy (HSA) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'HITEC University',
  lower(regexp_replace('HITEC University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'hitec-university',
  'HITEC',
  array['HITEC University']::text[],
  'HITEC University (HITEC) is located in Taxila, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Taxila',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Ibadat International University',
  lower(regexp_replace('Ibadat International University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'ibadat-international-university',
  null,
  array['Ibadat International University']::text[],
  'Ibadat International University is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Ilma University',
  lower(regexp_replace('Ilma University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'ilma-university',
  'ILMA',
  array['Ilma University']::text[],
  'Ilma University (ILMA) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Independent Medical College',
  lower(regexp_replace('Independent Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'independent-medical-college',
  'IMC',
  array['Independent Medical College']::text[],
  'Independent Medical College (IMC) is located in Faisalabad, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Faisalabad',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Indus University',
  lower(regexp_replace('Indus University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'indus-university',
  'IU',
  array['Indus University']::text[],
  'Indus University (IU) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Institute of Business Administration',
  lower(regexp_replace('Institute of Business Administration', '[^a-zA-Z0-9]+', ' ', 'g')),
  'institute-of-business-administration',
  'IBA',
  array['Institute of Business Administration']::text[],
  'Institute of Business Administration (IBA) is a business and management institution in Karachi. Business, management and finance programmes. Members compare programmes, internships and campus life.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Institute of Business and Technology',
  lower(regexp_replace('Institute of Business and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'institute-of-business-and-technology',
  'IBT',
  array['Institute of Business and Technology']::text[],
  'Institute of Business and Technology (IBT) is an engineering and applied-sciences institution in Karachi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Institute of Business Management',
  lower(regexp_replace('Institute of Business Management', '[^a-zA-Z0-9]+', ' ', 'g')),
  'institute-of-business-management',
  'IoBM',
  array['Institute of Business Management']::text[],
  'Institute of Business Management (IoBM) is a business and management institution in Karachi. Business, management and finance programmes. Members compare programmes, internships and campus life.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Institute of Cost and Management Accountants of Pakistan',
  lower(regexp_replace('Institute of Cost and Management Accountants of Pakistan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'institute-of-cost-and-management-accountants-of-pakistan',
  'ICMAP',
  array['Institute of Cost and Management Accountants of Pakistan']::text[],
  'Institute of Cost and Management Accountants of Pakistan (ICMAP) is a business and management institution in Karachi. Business, management and finance programmes. Members compare programmes, internships and campus life.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Institute of Space Technology',
  lower(regexp_replace('Institute of Space Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'institute-of-space-technology',
  'IST',
  array['Institute of Space Technology']::text[],
  'Institute of Space Technology (IST) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'International Islamic University',
  lower(regexp_replace('International Islamic University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'international-islamic-university',
  'IIUI',
  array['International Islamic University']::text[],
  'International Islamic University (IIUI) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Iqra National University',
  lower(regexp_replace('Iqra National University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'iqra-national-university',
  'INU',
  array['Iqra National University']::text[],
  'Iqra National University (INU) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Iqra University',
  lower(regexp_replace('Iqra University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'iqra-university',
  'IQRA',
  array['Iqra University']::text[],
  'Iqra University (IQRA) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Islam Medical College',
  lower(regexp_replace('Islam Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'islam-medical-college',
  'Islam MC',
  array['Islam Medical College']::text[],
  'Islam Medical College (Islam MC) is located in Sialkot, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sialkot',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Islamabad Medical and Dental College',
  lower(regexp_replace('Islamabad Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'islamabad-medical-and-dental-college',
  'IMDC',
  array['Islamabad Medical and Dental College']::text[],
  'Islamabad Medical and Dental College (IMDC) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Islamabad University of Health Sciences and Emerging Technologies',
  lower(regexp_replace('Islamabad University of Health Sciences and Emerging Technologies', '[^a-zA-Z0-9]+', ' ', 'g')),
  'islamabad-university-of-health-sciences-and-emerging-technologies',
  null,
  array['Islamabad University of Health Sciences and Emerging Technologies']::text[],
  'Islamabad University of Health Sciences and Emerging Technologies is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Islamia College University',
  lower(regexp_replace('Islamia College University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'islamia-college-university',
  'ICU',
  array['Islamia College University']::text[],
  'Islamia College University (ICU) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Islamia University of Bahawalpur',
  lower(regexp_replace('Islamia University of Bahawalpur', '[^a-zA-Z0-9]+', ' ', 'g')),
  'islamia-university-of-bahawalpur',
  'IUB',
  array['Islamia University of Bahawalpur']::text[],
  'Islamia University of Bahawalpur (IUB) is located in Bahawalpur, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Bahawalpur',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Isra University',
  lower(regexp_replace('Isra University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'isra-university',
  'ISRA',
  array['Isra University']::text[],
  'Isra University (ISRA) is located in Hyderabad, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Hyderabad',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Jinnah Sindh Medical University',
  lower(regexp_replace('Jinnah Sindh Medical University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'jinnah-sindh-medical-university',
  'JSMU',
  array['Jinnah Sindh Medical University']::text[],
  'Jinnah Sindh Medical University (JSMU) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Kabir Medical College',
  lower(regexp_replace('Kabir Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'kabir-medical-college',
  'KMC',
  array['Kabir Medical College']::text[],
  'Kabir Medical College (KMC) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Karachi Institute of Economics and Technology',
  lower(regexp_replace('Karachi Institute of Economics and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'karachi-institute-of-economics-and-technology',
  'KIET',
  array['Karachi Institute of Economics and Technology']::text[],
  'Karachi Institute of Economics and Technology (KIET) is an engineering and applied-sciences institution in Karachi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Karakoram International University',
  lower(regexp_replace('Karakoram International University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'karakoram-international-university',
  'KIU',
  array['Karakoram International University']::text[],
  'Karakoram International University (KIU) is located in Gilgit, Gilgit-Baltistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Gilgit',
  'Gilgit-Baltistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Khwaja Fareed University of Engineering and Information Technology',
  lower(regexp_replace('Khwaja Fareed University of Engineering and Information Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'khwaja-fareed-university-of-engineering-and-information-technology',
  'KFUEIT',
  array['Khwaja Fareed University of Engineering and Information Technology']::text[],
  'Khwaja Fareed University of Engineering and Information Technology (KFUEIT) is an engineering and applied-sciences institution in Rahim Yar Khan. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Rahim Yar Khan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Khyber Girls Medical College',
  lower(regexp_replace('Khyber Girls Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'khyber-girls-medical-college',
  'KGMC',
  array['Khyber Girls Medical College']::text[],
  'Khyber Girls Medical College (KGMC) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'King Edward Medical University',
  lower(regexp_replace('King Edward Medical University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'king-edward-medical-university',
  'KEMU',
  array['King Edward Medical University']::text[],
  'King Edward Medical University (KEMU) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Kinnaird College for Women',
  lower(regexp_replace('Kinnaird College for Women', '[^a-zA-Z0-9]+', ' ', 'g')),
  'kinnaird-college-for-women',
  'KCW',
  array['Kinnaird College for Women']::text[],
  'Kinnaird College for Women (KCW) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Kohat University of Science and Technology',
  lower(regexp_replace('Kohat University of Science and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'kohat-university-of-science-and-technology',
  'KUST',
  array['Kohat University of Science and Technology']::text[],
  'Kohat University of Science and Technology (KUST) is an engineering and applied-sciences institution in Kohat. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Kohat',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Lahore College for Women University',
  lower(regexp_replace('Lahore College for Women University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'lahore-college-for-women-university',
  'LCWU',
  array['Lahore College for Women University']::text[],
  'Lahore College for Women University (LCWU) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Lahore Garrison University',
  lower(regexp_replace('Lahore Garrison University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'lahore-garrison-university',
  'LGU',
  array['Lahore Garrison University']::text[],
  'Lahore Garrison University (LGU) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Lahore Leads University',
  lower(regexp_replace('Lahore Leads University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'lahore-leads-university',
  'LLU',
  array['Lahore Leads University']::text[],
  'Lahore Leads University (LLU) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Lahore Medical and Dental College',
  lower(regexp_replace('Lahore Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'lahore-medical-and-dental-college',
  'LMDC',
  array['Lahore Medical and Dental College']::text[],
  'Lahore Medical and Dental College (LMDC) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Lahore School of Economics',
  lower(regexp_replace('Lahore School of Economics', '[^a-zA-Z0-9]+', ' ', 'g')),
  'lahore-school-of-economics',
  'LSE',
  array['Lahore School of Economics']::text[],
  'Lahore School of Economics (LSE) is a business and management institution in Lahore. Business, management and finance programmes. Members compare programmes, internships and campus life.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Lahore University of Biological and Applied Sciences',
  lower(regexp_replace('Lahore University of Biological and Applied Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'lahore-university-of-biological-and-applied-sciences',
  'LUBAS',
  array['Lahore University of Biological and Applied Sciences']::text[],
  'Lahore University of Biological and Applied Sciences (LUBAS) is an engineering and applied-sciences institution in Lahore. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Lahore University of Management Sciences',
  lower(regexp_replace('Lahore University of Management Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'lahore-university-of-management-sciences',
  'LUMS',
  array['Lahore University of Management Sciences']::text[],
  'Lahore University of Management Sciences (LUMS) is an engineering and applied-sciences institution in Lahore. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Lasbela University of Agriculture, Water and Marine Sciences',
  lower(regexp_replace('Lasbela University of Agriculture, Water and Marine Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'lasbela-university-of-agriculture-water-and-marine-sciences',
  'LUAWMS',
  array['Lasbela University of Agriculture, Water and Marine Sciences']::text[],
  'Lasbela University of Agriculture, Water and Marine Sciences (LUAWMS) is an engineering and applied-sciences institution in Uthal. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Uthal',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Liaquat University of Medical and Health Sciences',
  lower(regexp_replace('Liaquat University of Medical and Health Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'liaquat-university-of-medical-and-health-sciences',
  'LUMHS',
  array['Liaquat University of Medical and Health Sciences']::text[],
  'Liaquat University of Medical and Health Sciences (LUMHS) is an engineering and applied-sciences institution in Jamshoro. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Jamshoro',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'M. Islam Medical College',
  lower(regexp_replace('M. Islam Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'm-islam-medical-college',
  'MIMC',
  array['M. Islam Medical College']::text[],
  'M. Islam Medical College (MIMC) is located in Gujranwala, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Gujranwala',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Margalla Institute of Health Sciences',
  lower(regexp_replace('Margalla Institute of Health Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'margalla-institute-of-health-sciences',
  'MIHS',
  array['Margalla Institute of Health Sciences']::text[],
  'Margalla Institute of Health Sciences (MIHS) is an engineering and applied-sciences institution in Rawalpindi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Rawalpindi',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Mehran University of Engineering and Technology',
  lower(regexp_replace('Mehran University of Engineering and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'mehran-university-of-engineering-and-technology',
  'MUET',
  array['Mehran University of Engineering and Technology']::text[],
  'Mehran University of Engineering and Technology (MUET) is an engineering and applied-sciences institution in Jamshoro. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Jamshoro',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Minhaj University',
  lower(regexp_replace('Minhaj University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'minhaj-university',
  'MUL',
  array['Minhaj University']::text[],
  'Minhaj University (MUL) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Mirpur University of Science and Technology',
  lower(regexp_replace('Mirpur University of Science and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'mirpur-university-of-science-and-technology',
  'MUST AJK',
  array['Mirpur University of Science and Technology', 'mirpur university of science and technology must']::text[],
  'Mirpur University of Science and Technology (MUST AJK) is an engineering and applied-sciences institution in Mirpur. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Mirpur',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Mohi-ud-Din Islamic University',
  lower(regexp_replace('Mohi-ud-Din Islamic University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'mohi-ud-din-islamic-university',
  'MIU',
  array['Mohi-ud-Din Islamic University']::text[],
  'Mohi-ud-Din Islamic University (MIU) is located in Nerian Sharif, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Nerian Sharif',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Mohtarma Benazir Bhutto Shaheed Medical College',
  lower(regexp_replace('Mohtarma Benazir Bhutto Shaheed Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'mohtarma-benazir-bhutto-shaheed-medical-college',
  'MBBSMC',
  array['Mohtarma Benazir Bhutto Shaheed Medical College']::text[],
  'Mohtarma Benazir Bhutto Shaheed Medical College (MBBSMC) is located in Mirpur, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Mirpur',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Multan Medical and Dental College',
  lower(regexp_replace('Multan Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'multan-medical-and-dental-college',
  'MMDC',
  array['Multan Medical and Dental College']::text[],
  'Multan Medical and Dental College (MMDC) is located in Multan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Multan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Multan University of Science and Technology',
  lower(regexp_replace('Multan University of Science and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'multan-university-of-science-and-technology',
  'MUST Multan',
  array['Multan University of Science and Technology']::text[],
  'Multan University of Science and Technology (MUST Multan) is an engineering and applied-sciences institution in Multan. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Multan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National College of Arts',
  lower(regexp_replace('National College of Arts', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-college-of-arts',
  'NCA',
  array['National College of Arts']::text[],
  'National College of Arts (NCA) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National College of Business Administration & Economics',
  lower(regexp_replace('National College of Business Administration & Economics', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-college-of-business-administration-and-economics',
  'NCBA&E',
  array['National College of Business Administration & Economics']::text[],
  'National College of Business Administration & Economics (NCBA&E) is a business and management institution in Lahore. Business, management and finance programmes. Members compare programmes, internships and campus life.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National Defence University',
  lower(regexp_replace('National Defence University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-defence-university',
  'NDU',
  array['National Defence University']::text[],
  'National Defence University (NDU) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National Textile University',
  lower(regexp_replace('National Textile University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-textile-university',
  'NTU',
  array['National Textile University']::text[],
  'National Textile University (NTU) is an engineering and applied-sciences institution in Faisalabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Faisalabad',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National University of Medical Sciences',
  lower(regexp_replace('National University of Medical Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-university-of-medical-sciences',
  'NUMS',
  array['National University of Medical Sciences']::text[],
  'National University of Medical Sciences (NUMS) is an engineering and applied-sciences institution in Rawalpindi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Rawalpindi',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National University of Modern Languages',
  lower(regexp_replace('National University of Modern Languages', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-university-of-modern-languages',
  'NUML',
  array['National University of Modern Languages']::text[],
  'National University of Modern Languages (NUML) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National University of Pakistan',
  lower(regexp_replace('National University of Pakistan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-university-of-pakistan',
  'NUP',
  array['National University of Pakistan']::text[],
  'National University of Pakistan (NUP) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National University of Sciences and Technology',
  lower(regexp_replace('National University of Sciences and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-university-of-sciences-and-technology',
  'NUST',
  array['National University of Sciences and Technology']::text[],
  'National University of Sciences and Technology (NUST) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National University of Sciences and Technology School of Civil and Environmental Engineering',
  lower(regexp_replace('National University of Sciences and Technology School of Civil and Environmental Engineering', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-university-of-sciences-and-technology-school-of-civil-and-environmental-engineering',
  'NUST SCEE',
  array['National University of Sciences and Technology School of Civil and Environmental Engineering']::text[],
  'National University of Sciences and Technology School of Civil and Environmental Engineering (NUST SCEE) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'National University of Technology',
  lower(regexp_replace('National University of Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'national-university-of-technology',
  'NUTECH',
  array['National University of Technology']::text[],
  'National University of Technology (NUTECH) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Nazeer Hussain University',
  lower(regexp_replace('Nazeer Hussain University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'nazeer-hussain-university',
  'NHU',
  array['Nazeer Hussain University']::text[],
  'Nazeer Hussain University (NHU) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'NED University of Engineering and Technology',
  lower(regexp_replace('NED University of Engineering and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'ned-university-of-engineering-and-technology',
  'NEDUET',
  array['NED University of Engineering and Technology']::text[],
  'NED University of Engineering and Technology (NEDUET) is an engineering and applied-sciences institution in Karachi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Nishtar Medical University',
  lower(regexp_replace('Nishtar Medical University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'nishtar-medical-university',
  'NMU',
  array['Nishtar Medical University']::text[],
  'Nishtar Medical University (NMU) is located in Multan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Multan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Northwest School of Medicine',
  lower(regexp_replace('Northwest School of Medicine', '[^a-zA-Z0-9]+', ' ', 'g')),
  'northwest-school-of-medicine',
  'NWSM',
  array['Northwest School of Medicine']::text[],
  'Northwest School of Medicine (NWSM) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Pak-Austria Fachhochschule Institute of Applied Sciences and Technology',
  lower(regexp_replace('Pak-Austria Fachhochschule Institute of Applied Sciences and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'pak-austria-fachhochschule-institute-of-applied-sciences-and-technology',
  'PAF-IAST',
  array['Pak-Austria Fachhochschule Institute of Applied Sciences and Technology']::text[],
  'Pak-Austria Fachhochschule Institute of Applied Sciences and Technology (PAF-IAST) is an engineering and applied-sciences institution in Haripur. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Haripur',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Pakistan Institute of Community Ophthalmology',
  lower(regexp_replace('Pakistan Institute of Community Ophthalmology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'pakistan-institute-of-community-ophthalmology',
  'PICO',
  array['Pakistan Institute of Community Ophthalmology']::text[],
  'Pakistan Institute of Community Ophthalmology (PICO) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Pakistan Institute of Development Economics',
  lower(regexp_replace('Pakistan Institute of Development Economics', '[^a-zA-Z0-9]+', ' ', 'g')),
  'pakistan-institute-of-development-economics',
  'PIDE',
  array['Pakistan Institute of Development Economics']::text[],
  'Pakistan Institute of Development Economics (PIDE) is a business and management institution in Islamabad. Business, management and finance programmes. Members compare programmes, internships and campus life.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Pakistan Institute of Engineering and Applied Sciences',
  lower(regexp_replace('Pakistan Institute of Engineering and Applied Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'pakistan-institute-of-engineering-and-applied-sciences',
  'PIEAS',
  array['Pakistan Institute of Engineering and Applied Sciences']::text[],
  'Pakistan Institute of Engineering and Applied Sciences (PIEAS) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Pakistan Institute of Fashion and Design',
  lower(regexp_replace('Pakistan Institute of Fashion and Design', '[^a-zA-Z0-9]+', ' ', 'g')),
  'pakistan-institute-of-fashion-and-design',
  'PIFD',
  array['Pakistan Institute of Fashion and Design']::text[],
  'Pakistan Institute of Fashion and Design (PIFD) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Pakistan Institute of Medical Sciences',
  lower(regexp_replace('Pakistan Institute of Medical Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'pakistan-institute-of-medical-sciences',
  'PIMS',
  array['Pakistan Institute of Medical Sciences']::text[],
  'Pakistan Institute of Medical Sciences (PIMS) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Pakistan Marine Academy',
  lower(regexp_replace('Pakistan Marine Academy', '[^a-zA-Z0-9]+', ' ', 'g')),
  'pakistan-marine-academy',
  null,
  array['Pakistan Marine Academy']::text[],
  'Pakistan Marine Academy is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'People''s University of Medical and Health Sciences for Women',
  lower(regexp_replace('People''s University of Medical and Health Sciences for Women', '[^a-zA-Z0-9]+', ' ', 'g')),
  'people-s-university-of-medical-and-health-sciences-for-women',
  null,
  array['People''s University of Medical and Health Sciences for Women']::text[],
  'People''s University of Medical and Health Sciences for Women is an engineering and applied-sciences institution in Nawabshah. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Nawabshah',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Peshawar Medical College',
  lower(regexp_replace('Peshawar Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'peshawar-medical-college',
  'PMC',
  array['Peshawar Medical College']::text[],
  'Peshawar Medical College (PMC) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Pir Mehr Ali Shah Arid Agriculture University',
  lower(regexp_replace('Pir Mehr Ali Shah Arid Agriculture University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'pir-mehr-ali-shah-arid-agriculture-university',
  'PMAS-AAUR',
  array['Pir Mehr Ali Shah Arid Agriculture University']::text[],
  'Pir Mehr Ali Shah Arid Agriculture University (PMAS-AAUR) is located in Rawalpindi, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalpindi',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Poonch Medical College',
  lower(regexp_replace('Poonch Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'poonch-medical-college',
  'PooMC',
  array['Poonch Medical College']::text[],
  'Poonch Medical College (PooMC) is located in Rawalakot, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalakot',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Preston Institute of Management Sciences and Technology',
  lower(regexp_replace('Preston Institute of Management Sciences and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'preston-institute-of-management-sciences-and-technology',
  'PIMSAT',
  array['Preston Institute of Management Sciences and Technology']::text[],
  'Preston Institute of Management Sciences and Technology (PIMSAT) is an engineering and applied-sciences institution in Karachi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Preston University',
  lower(regexp_replace('Preston University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'preston-university',
  'PRESTON',
  array['Preston University']::text[],
  'Preston University (PRESTON) is located in Kohat, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Kohat',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Punjab Tianjin University of Technology',
  lower(regexp_replace('Punjab Tianjin University of Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'punjab-tianjin-university-of-technology',
  'PTUT',
  array['Punjab Tianjin University of Technology']::text[],
  'Punjab Tianjin University of Technology (PTUT) is an engineering and applied-sciences institution in Lahore. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Qarshi University',
  lower(regexp_replace('Qarshi University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'qarshi-university',
  'QU',
  array['Qarshi University']::text[],
  'Qarshi University (QU) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Quaid-i-Awam University of Engineering, Science and Technology',
  lower(regexp_replace('Quaid-i-Awam University of Engineering, Science and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'quaid-i-awam-university-of-engineering-science-and-technology',
  'QUEST',
  array['Quaid-i-Awam University of Engineering, Science and Technology']::text[],
  'Quaid-i-Awam University of Engineering, Science and Technology (QUEST) is an engineering and applied-sciences institution in Shaheed Benazirabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Shaheed Benazirabad',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Quaid-i-Azam University',
  lower(regexp_replace('Quaid-i-Azam University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'quaid-i-azam-university',
  'QAU',
  array['Quaid-i-Azam University']::text[],
  'Quaid-i-Azam University (QAU) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Quetta Institute of Medical Sciences',
  lower(regexp_replace('Quetta Institute of Medical Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'quetta-institute-of-medical-sciences',
  'QIMS',
  array['Quetta Institute of Medical Sciences']::text[],
  'Quetta Institute of Medical Sciences (QIMS) is an engineering and applied-sciences institution in Quetta. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Quetta',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Qurtuba University of Science and Information Technology',
  lower(regexp_replace('Qurtuba University of Science and Information Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'qurtuba-university-of-science-and-information-technology',
  'QURTUBA',
  array['Qurtuba University of Science and Information Technology']::text[],
  'Qurtuba University of Science and Information Technology (QURTUBA) is an engineering and applied-sciences institution in Dera Ismail Khan. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Dera Ismail Khan',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Rashid Latif Medical College',
  lower(regexp_replace('Rashid Latif Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'rashid-latif-medical-college',
  'RLMC',
  array['Rashid Latif Medical College']::text[],
  'Rashid Latif Medical College (RLMC) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Rawal Institute of Health Sciences',
  lower(regexp_replace('Rawal Institute of Health Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'rawal-institute-of-health-sciences',
  'RIHS',
  array['Rawal Institute of Health Sciences']::text[],
  'Rawal Institute of Health Sciences (RIHS) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Rawalpindi Medical College',
  lower(regexp_replace('Rawalpindi Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'rawalpindi-medical-college',
  'RMC',
  array['Rawalpindi Medical College']::text[],
  'Rawalpindi Medical College (RMC) is located in Rawalpindi, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalpindi',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Rawalpindi Medical University',
  lower(regexp_replace('Rawalpindi Medical University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'rawalpindi-medical-university',
  'RMU',
  array['Rawalpindi Medical University']::text[],
  'Rawalpindi Medical University (RMU) is located in Rawalpindi, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalpindi',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Rawalpindi Women University',
  lower(regexp_replace('Rawalpindi Women University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'rawalpindi-women-university',
  null,
  array['Rawalpindi Women University']::text[],
  'Rawalpindi Women University is located in Rawalpindi, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalpindi',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Rehman College of Rehabilitation Sciences',
  lower(regexp_replace('Rehman College of Rehabilitation Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'rehman-college-of-rehabilitation-sciences',
  'RCRS',
  array['Rehman College of Rehabilitation Sciences']::text[],
  'Rehman College of Rehabilitation Sciences (RCRS) is an engineering and applied-sciences institution in Peshawar. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Riphah International University',
  lower(regexp_replace('Riphah International University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'riphah-international-university',
  'RIU',
  array['Riphah International University']::text[],
  'Riphah International University (RIU) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sahara Medical College',
  lower(regexp_replace('Sahara Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sahara-medical-college',
  'SAHARA',
  array['Sahara Medical College']::text[],
  'Sahara Medical College (SAHARA) is located in Narowal, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Narowal',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sardar Bahadur Khan Women University',
  lower(regexp_replace('Sardar Bahadur Khan Women University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sardar-bahadur-khan-women-university',
  'SBKWU',
  array['Sardar Bahadur Khan Women University']::text[],
  'Sardar Bahadur Khan Women University (SBKWU) is located in Quetta, Balochistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Quetta',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sarhad University of Science and Information Technology',
  lower(regexp_replace('Sarhad University of Science and Information Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sarhad-university-of-science-and-information-technology',
  'SUIT',
  array['Sarhad University of Science and Information Technology']::text[],
  'Sarhad University of Science and Information Technology (SUIT) is an engineering and applied-sciences institution in Peshawar. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shah Abdul Latif University',
  lower(regexp_replace('Shah Abdul Latif University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shah-abdul-latif-university',
  'SALU',
  array['Shah Abdul Latif University']::text[],
  'Shah Abdul Latif University (SALU) is located in Khairpur, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Khairpur',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shaheed Benazir Bhutto University',
  lower(regexp_replace('Shaheed Benazir Bhutto University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shaheed-benazir-bhutto-university',
  'SBBU',
  array['Shaheed Benazir Bhutto University']::text[],
  'Shaheed Benazir Bhutto University (SBBU) is located in Shaheed Benazirabad, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Shaheed Benazirabad',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shaheed Benazir Bhutto University of Veterinary and Animal Sciences',
  lower(regexp_replace('Shaheed Benazir Bhutto University of Veterinary and Animal Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shaheed-benazir-bhutto-university-of-veterinary-and-animal-sciences',
  'SBBUVAS',
  array['Shaheed Benazir Bhutto University of Veterinary and Animal Sciences']::text[],
  'Shaheed Benazir Bhutto University of Veterinary and Animal Sciences (SBBUVAS) is an engineering and applied-sciences institution in Sakrand. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Sakrand',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shaheed Benazir Bhutto University Sheringal',
  lower(regexp_replace('Shaheed Benazir Bhutto University Sheringal', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shaheed-benazir-bhutto-university-sheringal',
  'SBBU Sheringal',
  array['Shaheed Benazir Bhutto University Sheringal']::text[],
  'Shaheed Benazir Bhutto University Sheringal (SBBU Sheringal) is located in Sheringal, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sheringal',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shaheed Benazir Bhutto Women University',
  lower(regexp_replace('Shaheed Benazir Bhutto Women University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shaheed-benazir-bhutto-women-university',
  'SBBWU',
  array['Shaheed Benazir Bhutto Women University']::text[],
  'Shaheed Benazir Bhutto Women University (SBBWU) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shaheed Mohtarma Benazir Bhutto Medical University',
  lower(regexp_replace('Shaheed Mohtarma Benazir Bhutto Medical University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shaheed-mohtarma-benazir-bhutto-medical-university',
  'SMBBMU',
  array['Shaheed Mohtarma Benazir Bhutto Medical University']::text[],
  'Shaheed Mohtarma Benazir Bhutto Medical University (SMBBMU) is located in Larkana, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Larkana',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shaheed Zulfiqar Ali Bhutto Institute of Science and Technology',
  lower(regexp_replace('Shaheed Zulfiqar Ali Bhutto Institute of Science and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology',
  'SZABIST',
  array['Shaheed Zulfiqar Ali Bhutto Institute of Science and Technology', 'shaheed zulfiqar ali bhutto institute of science and technology szabist', 'szabist']::text[],
  'Shaheed Zulfiqar Ali Bhutto Institute of Science and Technology (SZABIST) is an engineering and applied-sciences institution in Karachi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shaikh Ayaz University',
  lower(regexp_replace('Shaikh Ayaz University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shaikh-ayaz-university',
  'SAU Shikarpur',
  array['Shaikh Ayaz University']::text[],
  'Shaikh Ayaz University (SAU Shikarpur) is located in Shikarpur, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Shikarpur',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shalamar Medical and Dental College',
  lower(regexp_replace('Shalamar Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shalamar-medical-and-dental-college',
  'SMDC Lahore',
  array['Shalamar Medical and Dental College']::text[],
  'Shalamar Medical and Dental College (SMDC Lahore) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sharif Medical and Dental College',
  lower(regexp_replace('Sharif Medical and Dental College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sharif-medical-and-dental-college',
  'SMDC',
  array['Sharif Medical and Dental College']::text[],
  'Sharif Medical and Dental College (SMDC) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shifa College of Medicine',
  lower(regexp_replace('Shifa College of Medicine', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shifa-college-of-medicine',
  'SCM',
  array['Shifa College of Medicine']::text[],
  'Shifa College of Medicine (SCM) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Shifa Tameer-e-Millat University',
  lower(regexp_replace('Shifa Tameer-e-Millat University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'shifa-tameer-e-millat-university',
  'STMU',
  array['Shifa Tameer-e-Millat University']::text[],
  'Shifa Tameer-e-Millat University (STMU) is located in Islamabad, Islamabad Capital Territory. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sialkot Medical College',
  lower(regexp_replace('Sialkot Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sialkot-medical-college',
  'SMC',
  array['Sialkot Medical College']::text[],
  'Sialkot Medical College (SMC) is located in Sialkot, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sialkot',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sindh Agriculture University',
  lower(regexp_replace('Sindh Agriculture University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sindh-agriculture-university',
  'SAU',
  array['Sindh Agriculture University']::text[],
  'Sindh Agriculture University (SAU) is located in Tandojam, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Tandojam',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sindh Institute of Medical Sciences',
  lower(regexp_replace('Sindh Institute of Medical Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sindh-institute-of-medical-sciences',
  null,
  array['Sindh Institute of Medical Sciences']::text[],
  'Sindh Institute of Medical Sciences is an engineering and applied-sciences institution in Karachi. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sindh Madressatul Islam University',
  lower(regexp_replace('Sindh Madressatul Islam University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sindh-madressatul-islam-university',
  'SMIU',
  array['Sindh Madressatul Islam University']::text[],
  'Sindh Madressatul Islam University (SMIU) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sir Syed CASE Institute of Technology',
  lower(regexp_replace('Sir Syed CASE Institute of Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sir-syed-case-institute-of-technology',
  'SSCIT',
  array['Sir Syed CASE Institute of Technology']::text[],
  'Sir Syed CASE Institute of Technology (SSCIT) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sughra Shafi Medical Complex',
  lower(regexp_replace('Sughra Shafi Medical Complex', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sughra-shafi-medical-complex',
  'SSMC',
  array['Sughra Shafi Medical Complex']::text[],
  'Sughra Shafi Medical Complex (SSMC) is located in Narowal, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Narowal',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Sukkur IBA University',
  lower(regexp_replace('Sukkur IBA University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'sukkur-iba-university',
  'SIBAU',
  array['Sukkur IBA University']::text[],
  'Sukkur IBA University (SIBAU) is located in Sukkur, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sukkur',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Superior University',
  lower(regexp_replace('Superior University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'superior-university',
  'SUPERIOR',
  array['Superior University']::text[],
  'Superior University (SUPERIOR) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Swat Medical College',
  lower(regexp_replace('Swat Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'swat-medical-college',
  'SMC Swat',
  array['Swat Medical College']::text[],
  'Swat Medical College (SMC Swat) is located in Swat, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Swat',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'The University of Faisalabad',
  lower(regexp_replace('The University of Faisalabad', '[^a-zA-Z0-9]+', ' ', 'g')),
  'the-university-of-faisalabad',
  'TUF',
  array['The University of Faisalabad', 'university of faisalabad']::text[],
  'The University of Faisalabad (TUF) is located in Faisalabad, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Faisalabad',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Agriculture Faisalabad',
  lower(regexp_replace('University of Agriculture Faisalabad', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-agriculture-faisalabad',
  'UAF',
  array['University of Agriculture Faisalabad']::text[],
  'University of Agriculture Faisalabad (UAF) is located in Faisalabad, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Faisalabad',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Attock',
  lower(regexp_replace('University of Attock', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-attock',
  null,
  array['University of Attock']::text[],
  'University of Attock is located in Attock, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Attock',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Azad Jammu and Kashmir',
  lower(regexp_replace('University of Azad Jammu and Kashmir', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-azad-jammu-and-kashmir',
  'UAJK',
  array['University of Azad Jammu and Kashmir']::text[],
  'University of Azad Jammu and Kashmir (UAJK) is located in Muzaffarabad, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Muzaffarabad',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Bahawalnagar',
  lower(regexp_replace('University of Bahawalnagar', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-bahawalnagar',
  null,
  array['University of Bahawalnagar']::text[],
  'University of Bahawalnagar is located in Bahawalnagar, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Bahawalnagar',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Balochistan',
  lower(regexp_replace('University of Balochistan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-balochistan',
  'UoB',
  array['University of Balochistan']::text[],
  'University of Balochistan (UoB) is located in Quetta, Balochistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Quetta',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Baltistan',
  lower(regexp_replace('University of Baltistan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-baltistan',
  'UoB Skardu',
  array['University of Baltistan']::text[],
  'University of Baltistan (UoB Skardu) is located in Baltistan, Gilgit-Baltistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Baltistan',
  'Gilgit-Baltistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Bhakkar',
  lower(regexp_replace('University of Bhakkar', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-bhakkar',
  null,
  array['University of Bhakkar']::text[],
  'University of Bhakkar is located in Bhakkar, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Bhakkar',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Buner',
  lower(regexp_replace('University of Buner', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-buner',
  null,
  array['University of Buner']::text[],
  'University of Buner is located in Buner, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Buner',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Central Punjab',
  lower(regexp_replace('University of Central Punjab', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-central-punjab',
  'UCP',
  array['University of Central Punjab']::text[],
  'University of Central Punjab (UCP) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Chakwal',
  lower(regexp_replace('University of Chakwal', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-chakwal',
  'UOC',
  array['University of Chakwal']::text[],
  'University of Chakwal (UOC) is located in Chakwal, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Chakwal',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Chenab',
  lower(regexp_replace('University of Chenab', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-chenab',
  'UOC',
  array['University of Chenab']::text[],
  'University of Chenab (UOC) is located in Gujrat, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Gujrat',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Child Health Sciences',
  lower(regexp_replace('University of Child Health Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-child-health-sciences',
  'UCHS',
  array['University of Child Health Sciences']::text[],
  'University of Child Health Sciences (UCHS) is an engineering and applied-sciences institution in Lahore. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Chitral',
  lower(regexp_replace('University of Chitral', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-chitral',
  'UoCh',
  array['University of Chitral']::text[],
  'University of Chitral (UoCh) is located in Chitral, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Chitral',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Dera Ghazi Khan',
  lower(regexp_replace('University of Dera Ghazi Khan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-dera-ghazi-khan',
  'UODGK',
  array['University of Dera Ghazi Khan']::text[],
  'University of Dera Ghazi Khan (UODGK) is located in Dera Ghazi Khan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Dera Ghazi Khan',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Education',
  lower(regexp_replace('University of Education', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-education',
  'UE',
  array['University of Education']::text[],
  'University of Education (UE) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Engineering and Technology Lahore',
  lower(regexp_replace('University of Engineering and Technology Lahore', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-engineering-and-technology-lahore',
  'UET Lahore',
  array['University of Engineering and Technology Lahore']::text[],
  'University of Engineering and Technology Lahore (UET Lahore) is an engineering and applied-sciences institution in Lahore. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Engineering and Technology Mardan',
  lower(regexp_replace('University of Engineering and Technology Mardan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-engineering-and-technology-mardan',
  'UET Mardan',
  array['University of Engineering and Technology Mardan']::text[],
  'University of Engineering and Technology Mardan (UET Mardan) is an engineering and applied-sciences institution in Mardan. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Mardan',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Engineering and Technology Peshawar',
  lower(regexp_replace('University of Engineering and Technology Peshawar', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-engineering-and-technology-peshawar',
  'UET Peshawar',
  array['University of Engineering and Technology Peshawar']::text[],
  'University of Engineering and Technology Peshawar (UET Peshawar) is an engineering and applied-sciences institution in Peshawar. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Engineering and Technology Taxila',
  lower(regexp_replace('University of Engineering and Technology Taxila', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-engineering-and-technology-taxila',
  'UET Taxila',
  array['University of Engineering and Technology Taxila']::text[],
  'University of Engineering and Technology Taxila (UET Taxila) is an engineering and applied-sciences institution in Taxila. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Taxila',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Gujrat',
  lower(regexp_replace('University of Gujrat', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-gujrat',
  'UOG',
  array['University of Gujrat']::text[],
  'University of Gujrat (UOG) is located in Gujrat, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Gujrat',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Gwadar',
  lower(regexp_replace('University of Gwadar', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-gwadar',
  'UOGw',
  array['University of Gwadar']::text[],
  'University of Gwadar (UOGw) is located in Gwadar, Balochistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Gwadar',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Hafizabad',
  lower(regexp_replace('University of Hafizabad', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-hafizabad',
  null,
  array['University of Hafizabad']::text[],
  'University of Hafizabad is located in Hafizabad, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Hafizabad',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Haripur',
  lower(regexp_replace('University of Haripur', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-haripur',
  'UOH',
  array['University of Haripur']::text[],
  'University of Haripur (UOH) is located in Haripur, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Haripur',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Health Sciences',
  lower(regexp_replace('University of Health Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-health-sciences',
  'UHS',
  array['University of Health Sciences']::text[],
  'University of Health Sciences (UHS) is an engineering and applied-sciences institution in Lahore. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Home Economics',
  lower(regexp_replace('University of Home Economics', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-home-economics',
  'UHE',
  array['University of Home Economics']::text[],
  'University of Home Economics (UHE) is a business and management institution in Lahore. Business, management and finance programmes. Members compare programmes, internships and campus life.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Jhang',
  lower(regexp_replace('University of Jhang', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-jhang',
  'UOJ',
  array['University of Jhang']::text[],
  'University of Jhang (UOJ) is located in Jhang, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Jhang',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Jhelum',
  lower(regexp_replace('University of Jhelum', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-jhelum',
  null,
  array['University of Jhelum']::text[],
  'University of Jhelum is located in Jhelum, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Jhelum',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Kamalia',
  lower(regexp_replace('University of Kamalia', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-kamalia',
  null,
  array['University of Kamalia']::text[],
  'University of Kamalia is located in Kamalia, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Kamalia',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Karachi',
  lower(regexp_replace('University of Karachi', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-karachi',
  'UoK',
  array['University of Karachi']::text[],
  'University of Karachi (UoK) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Kasur',
  lower(regexp_replace('University of Kasur', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-kasur',
  null,
  array['University of Kasur']::text[],
  'University of Kasur is located in Kasur, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Kasur',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Khanewal',
  lower(regexp_replace('University of Khanewal', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-khanewal',
  null,
  array['University of Khanewal']::text[],
  'University of Khanewal is located in Khanewal, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Khanewal',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Kharian',
  lower(regexp_replace('University of Kharian', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-kharian',
  null,
  array['University of Kharian']::text[],
  'University of Kharian is located in Kharian, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Kharian',
  'Khyber Pakhtunkhwa',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Kotli Azad Jammu and Kashmir',
  lower(regexp_replace('University of Kotli Azad Jammu and Kashmir', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-kotli-azad-jammu-and-kashmir',
  'UKAJK',
  array['University of Kotli Azad Jammu and Kashmir']::text[],
  'University of Kotli Azad Jammu and Kashmir (UKAJK) is located in Kotli, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Kotli',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Lahore',
  lower(regexp_replace('University of Lahore', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-lahore',
  'UOL',
  array['University of Lahore']::text[],
  'University of Lahore (UOL) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Lakki Marwat',
  lower(regexp_replace('University of Lakki Marwat', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-lakki-marwat',
  null,
  array['University of Lakki Marwat']::text[],
  'University of Lakki Marwat is located in Lakki Marwat, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lakki Marwat',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Larkano',
  lower(regexp_replace('University of Larkano', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-larkano',
  'UOLar',
  array['University of Larkano']::text[],
  'University of Larkano (UOLar) is located in Larkana, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Larkana',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Layyah',
  lower(regexp_replace('University of Layyah', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-layyah',
  'UOLY',
  array['University of Layyah']::text[],
  'University of Layyah (UOLY) is located in Layyah, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Layyah',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Lodhran',
  lower(regexp_replace('University of Lodhran', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-lodhran',
  null,
  array['University of Lodhran']::text[],
  'University of Lodhran is located in Lodhran, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lodhran',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Loralai',
  lower(regexp_replace('University of Loralai', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-loralai',
  'UoL',
  array['University of Loralai']::text[],
  'University of Loralai (UoL) is located in Loralai, Balochistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Loralai',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Makran',
  lower(regexp_replace('University of Makran', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-makran',
  'UoM',
  array['University of Makran']::text[],
  'University of Makran (UoM) is located in Makran, Balochistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Makran',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Malakand',
  lower(regexp_replace('University of Malakand', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-malakand',
  'UOM',
  array['University of Malakand']::text[],
  'University of Malakand (UOM) is located in Malakand, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Malakand',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Management and Technology',
  lower(regexp_replace('University of Management and Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-management-and-technology',
  'UMT',
  array['University of Management and Technology']::text[],
  'University of Management and Technology (UMT) is an engineering and applied-sciences institution in Lahore. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Mianwali',
  lower(regexp_replace('University of Mianwali', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-mianwali',
  'UOMW',
  array['University of Mianwali']::text[],
  'University of Mianwali (UOMW) is located in Mianwali, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Mianwali',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Mirpurkhas',
  lower(regexp_replace('University of Mirpurkhas', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-mirpurkhas',
  'UOMir',
  array['University of Mirpurkhas']::text[],
  'University of Mirpurkhas (UOMir) is located in Mirpurkhas, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Mirpurkhas',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Murree',
  lower(regexp_replace('University of Murree', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-murree',
  null,
  array['University of Murree']::text[],
  'University of Murree is in Pakistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  null,
  null,
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Muzaffargarh',
  lower(regexp_replace('University of Muzaffargarh', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-muzaffargarh',
  null,
  array['University of Muzaffargarh']::text[],
  'University of Muzaffargarh is located in Muzaffargarh, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Muzaffargarh',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Narowal',
  lower(regexp_replace('University of Narowal', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-narowal',
  'UON',
  array['University of Narowal']::text[],
  'University of Narowal (UON) is located in Narowal, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Narowal',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Neelum',
  lower(regexp_replace('University of Neelum', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-neelum',
  'UoN',
  array['University of Neelum']::text[],
  'University of Neelum (UoN) is located in Athmuqam, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Athmuqam',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Okara',
  lower(regexp_replace('University of Okara', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-okara',
  'UOO',
  array['University of Okara']::text[],
  'University of Okara (UOO) is located in Okara, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Okara',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Pakpattan',
  lower(regexp_replace('University of Pakpattan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-pakpattan',
  null,
  array['University of Pakpattan']::text[],
  'University of Pakpattan is located in Pakpattan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Pakpattan',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Peshawar',
  lower(regexp_replace('University of Peshawar', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-peshawar',
  'UoP',
  array['University of Peshawar']::text[],
  'University of Peshawar (UoP) is located in Peshawar, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Peshawar',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Poonch',
  lower(regexp_replace('University of Poonch', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-poonch',
  'UOP',
  array['University of Poonch', 'university of poonch rawalakot']::text[],
  'University of Poonch (UOP) is located in Rawalakot, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalakot',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Rahim Yar Khan',
  lower(regexp_replace('University of Rahim Yar Khan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-rahim-yar-khan',
  null,
  array['University of Rahim Yar Khan']::text[],
  'University of Rahim Yar Khan is located in Rahim Yar Khan, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rahim Yar Khan',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Rajanpur',
  lower(regexp_replace('University of Rajanpur', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-rajanpur',
  null,
  array['University of Rajanpur']::text[],
  'University of Rajanpur is located in Rajanpur, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rajanpur',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Rawalpindi',
  lower(regexp_replace('University of Rawalpindi', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-rawalpindi',
  null,
  array['University of Rawalpindi']::text[],
  'University of Rawalpindi is located in Rawalpindi, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Rawalpindi',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Sahiwal',
  lower(regexp_replace('University of Sahiwal', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-sahiwal',
  'UOSah',
  array['University of Sahiwal']::text[],
  'University of Sahiwal (UOSah) is located in Sahiwal, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sahiwal',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Sargodha',
  lower(regexp_replace('University of Sargodha', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-sargodha',
  'UoS Sargodha',
  array['University of Sargodha']::text[],
  'University of Sargodha (UoS Sargodha) is located in Sargodha, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sargodha',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Shangla',
  lower(regexp_replace('University of Shangla', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-shangla',
  'UoSh',
  array['University of Shangla']::text[],
  'University of Shangla (UoSh) is located in Shangla, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Shangla',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Sheikhupura',
  lower(regexp_replace('University of Sheikhupura', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-sheikhupura',
  null,
  array['University of Sheikhupura']::text[],
  'University of Sheikhupura is located in Sheikhupura, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sheikhupura',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Sialkot',
  lower(regexp_replace('University of Sialkot', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-sialkot',
  'UOS',
  array['University of Sialkot']::text[],
  'University of Sialkot (UOS) is located in Sialkot, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Sialkot',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Sindh',
  lower(regexp_replace('University of Sindh', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-sindh',
  'UoS',
  array['University of Sindh']::text[],
  'University of Sindh (UoS) is located in Jamshoro, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Jamshoro',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Sufism and Modern Sciences',
  lower(regexp_replace('University of Sufism and Modern Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-sufism-and-modern-sciences',
  'USMS',
  array['University of Sufism and Modern Sciences']::text[],
  'University of Sufism and Modern Sciences (USMS) is an engineering and applied-sciences institution in Bhitshah. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Bhitshah',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Swabi',
  lower(regexp_replace('University of Swabi', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-swabi',
  'UOSW',
  array['University of Swabi']::text[],
  'University of Swabi (UOSW) is located in Swabi, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Swabi',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Swat',
  lower(regexp_replace('University of Swat', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-swat',
  'UOSw',
  array['University of Swat']::text[],
  'University of Swat (UOSw) is located in Swat, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Swat',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Taunsa',
  lower(regexp_replace('University of Taunsa', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-taunsa',
  null,
  array['University of Taunsa']::text[],
  'University of Taunsa is located in Taunsa, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Taunsa',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Taxila',
  lower(regexp_replace('University of Taxila', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-taxila',
  null,
  array['University of Taxila']::text[],
  'University of Taxila is located in Taxila, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Taxila',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Technology',
  lower(regexp_replace('University of Technology', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-technology',
  'UoT Nowshera',
  array['University of Technology']::text[],
  'University of Technology (UoT Nowshera) is an engineering and applied-sciences institution in Nowshera. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Nowshera',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Turbat',
  lower(regexp_replace('University of Turbat', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-turbat',
  'UoT',
  array['University of Turbat']::text[],
  'University of Turbat (UoT) is located in Turbat, Balochistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Turbat',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Vehari',
  lower(regexp_replace('University of Vehari', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-vehari',
  null,
  array['University of Vehari']::text[],
  'University of Vehari is located in Vehari, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Vehari',
  'Punjab',
  'pending_review'::public.university_status,
  false,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Veterinary and Animal Sciences',
  lower(regexp_replace('University of Veterinary and Animal Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-veterinary-and-animal-sciences',
  'UVAS',
  array['University of Veterinary and Animal Sciences']::text[],
  'University of Veterinary and Animal Sciences (UVAS) is an engineering and applied-sciences institution in Lahore. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Wah',
  lower(regexp_replace('University of Wah', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-wah',
  'UOW',
  array['University of Wah']::text[],
  'University of Wah (UOW) is located in Wah Cantt, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Wah Cantt',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Women Mardan',
  lower(regexp_replace('University of Women Mardan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-women-mardan',
  'UWM',
  array['University of Women Mardan']::text[],
  'University of Women Mardan (UWM) is located in Mardan, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Mardan',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'University of Zhob',
  lower(regexp_replace('University of Zhob', '[^a-zA-Z0-9]+', ' ', 'g')),
  'university-of-zhob',
  'UoZ',
  array['University of Zhob']::text[],
  'University of Zhob (UoZ) is located in Zhob, Balochistan. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Zhob',
  'Balochistan',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Virtual University of Pakistan',
  lower(regexp_replace('Virtual University of Pakistan', '[^a-zA-Z0-9]+', ' ', 'g')),
  'virtual-university-of-pakistan',
  'VU',
  array['Virtual University of Pakistan']::text[],
  'Virtual University of Pakistan (VU) is located in Lahore, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Lahore',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Wah Medical College',
  lower(regexp_replace('Wah Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'wah-medical-college',
  'WMC Wah',
  array['Wah Medical College']::text[],
  'Wah Medical College (WMC Wah) is located in Wah Cantt, Punjab. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Wah Cantt',
  'Punjab',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Women Medical College',
  lower(regexp_replace('Women Medical College', '[^a-zA-Z0-9]+', ' ', 'g')),
  'women-medical-college',
  'WMC',
  array['Women Medical College']::text[],
  'Women Medical College (WMC) is located in Abbottabad, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Abbottabad',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Women University of Azad Jammu and Kashmir',
  lower(regexp_replace('Women University of Azad Jammu and Kashmir', '[^a-zA-Z0-9]+', ' ', 'g')),
  'women-university-of-azad-jammu-and-kashmir',
  'WUAJK',
  array['Women University of Azad Jammu and Kashmir']::text[],
  'Women University of Azad Jammu and Kashmir (WUAJK) is located in Bagh, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Bagh',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Women University of Bagh',
  lower(regexp_replace('Women University of Bagh', '[^a-zA-Z0-9]+', ' ', 'g')),
  'women-university-of-bagh',
  'WUB',
  array['Women University of Bagh']::text[],
  'Women University of Bagh (WUB) is located in Bagh, Azad Jammu and Kashmir. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Bagh',
  'Azad Jammu and Kashmir',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Women University Swabi',
  lower(regexp_replace('Women University Swabi', '[^a-zA-Z0-9]+', ' ', 'g')),
  'women-university-swabi',
  'WUS',
  array['Women University Swabi']::text[],
  'Women University Swabi (WUS) is located in Swabi, Khyber Pakhtunkhwa. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Swabi',
  'Khyber Pakhtunkhwa',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Yusra Institute of Pharmaceutical Sciences',
  lower(regexp_replace('Yusra Institute of Pharmaceutical Sciences', '[^a-zA-Z0-9]+', ' ', 'g')),
  'yusra-institute-of-pharmaceutical-sciences',
  'YIPS',
  array['Yusra Institute of Pharmaceutical Sciences']::text[],
  'Yusra Institute of Pharmaceutical Sciences (YIPS) is an engineering and applied-sciences institution in Islamabad. Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.',
  'Islamabad',
  'Islamabad Capital Territory',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();
insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  'Ziauddin University',
  lower(regexp_replace('Ziauddin University', '[^a-zA-Z0-9]+', ' ', 'g')),
  'ziauddin-university',
  'ZIU',
  array['Ziauddin University']::text[],
  'Ziauddin University (ZIU) is located in Karachi, Sindh. A student community for this campus — announcements, questions and everyday campus conversation.',
  'Karachi',
  'Sindh',
  'active'::public.university_status,
  true,
  false
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();

-- 2. Campuses ----------------------------------------------------------------
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'abasyn-university-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'abasyn-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'abasyn-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'abasyn-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Abbottabad', 'abbottabad-international-medical-college-abbottabad', 'Abbottabad', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'abbottabad-international-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'abbottabad-university-of-science-and-technology-main-campus', 'Abbottabad', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'abbottabad-university-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'abdul-wali-khan-university-mardan-main-campus', 'Mardan', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'abdul-wali-khan-university-mardan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'aga-khan-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'aga-khan-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'air-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'air-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan Campus', 'air-university-multan-campus', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'air-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kamra Campus', 'air-university-kamra-campus', 'Kamra', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'air-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kharian Campus', 'air-university-kharian-campus', 'Kharian', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'air-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'air-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'air-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'air-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'air-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'akhtar-saeed-medical-and-dental-college-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'akhtar-saeed-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Quetta Campus', 'al-hamd-islamic-university-quetta-campus', 'Quetta', 'Balochistan', false, true
from public.universities u where u.slug = 'al-hamd-islamic-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'al-hamd-islamic-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'al-hamd-islamic-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'al-kawthar-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'al-kawthar-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rashidabad Campus', 'al-kawthar-university-rashidabad-campus', null, null, false, true
from public.universities u where u.slug = 'al-kawthar-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'allama-iqbal-open-university-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'allama-iqbal-open-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi', 'army-medical-college-rawalpindi', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'army-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Muzaffarabad', 'azad-jammu-and-kashmir-medical-college-muzaffarabad', 'Muzaffarabad', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'azad-jammu-and-kashmir-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad', 'aziz-fatimah-medical-and-dental-college-faisalabad', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'aziz-fatimah-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'azra-naheed-medical-college-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'azra-naheed-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'baba-guru-nanak-university-main-campus', 'Nankana Sahib', 'Punjab', true, true
from public.universities u where u.slug = 'baba-guru-nanak-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan Campus', 'bahauddin-zakariya-university-multan-campus', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'bahauddin-zakariya-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Vehari Campus', 'bahauddin-zakariya-university-vehari-campus', 'Vehari', 'Punjab', false, true
from public.universities u where u.slug = 'bahauddin-zakariya-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lodhran Campus', 'bahauddin-zakariya-university-lodhran-campus', 'Lodhran', 'Punjab', false, true
from public.universities u where u.slug = 'bahauddin-zakariya-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'bahria-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'bahria-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'bahria-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'bahria-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'bahria-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'bahria-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi', 'bahria-university-medical-and-dental-college-karachi', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'bahria-university-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan', 'bakhtawar-amin-medical-and-dental-college-multan', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'bakhtawar-amin-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Khuzdar Campus', 'balochistan-university-of-engineering-and-technology-khuzdar-campus', 'Khuzdar', 'Balochistan', false, true
from public.universities u where u.slug = 'balochistan-university-of-engineering-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Uthal Campus', 'balochistan-university-of-engineering-and-technology-uthal-campus', 'Uthal', 'Balochistan', false, true
from public.universities u where u.slug = 'balochistan-university-of-engineering-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Quetta Campus', 'balochistan-university-of-information-technology-engineering-and-management-sciences-quetta-campus', 'Quetta', 'Balochistan', false, true
from public.universities u where u.slug = 'balochistan-university-of-information-technology-engineering-and-management-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Zhob Campus', 'balochistan-university-of-information-technology-engineering-and-management-sciences-zhob-campus', 'Zhob', 'Balochistan', false, true
from public.universities u where u.slug = 'balochistan-university-of-information-technology-engineering-and-management-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bannu', 'bannu-medical-college-bannu', 'Bannu', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'bannu-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'bashir-institute-of-health-sciences-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'bashir-institute-of-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sukkur', 'begum-nusrat-bhutto-women-university-sukkur', 'Sukkur', 'Sindh', false, true
from public.universities u where u.slug = 'begum-nusrat-bhutto-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lyari Campus', 'benazir-bhutto-shaheed-university-lyari-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'benazir-bhutto-shaheed-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Khairpur Mirs Campus', 'benazir-bhutto-shaheed-university-of-technology-and-skill-development-khairpur-mirs-campus', 'Khairpur Mirs', 'Sindh', false, true
from public.universities u where u.slug = 'benazir-bhutto-shaheed-university-of-technology-and-skill-development'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'bolan-university-of-medical-and-health-sciences-main-campus', 'Bolan', 'Balochistan', true, true
from public.universities u where u.slug = 'bolan-university-of-medical-and-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'capital-university-of-science-and-technology-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'capital-university-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'cecos-university-of-information-technology-and-emerging-sciences-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'cecos-university-of-information-technology-and-emerging-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'central-park-medical-college-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'central-park-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'cholistan-university-of-veterinary-and-animal-sciences-main-campus', 'Bahawalpur', 'Punjab', true, true
from public.universities u where u.slug = 'cholistan-university-of-veterinary-and-animal-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'city-university-of-science-and-information-technology-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'city-university-of-science-and-information-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'cmh-lahore-medical-college-and-institute-of-dentistry-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'cmh-lahore-medical-college-and-institute-of-dentistry'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'comsats-university-islamabad-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'comsats-university-islamabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Abbottabad Campus', 'comsats-university-islamabad-abbottabad-campus', 'Abbottabad', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'comsats-university-islamabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Attock Campus', 'comsats-university-islamabad-attock-campus', 'Attock', 'Punjab', false, true
from public.universities u where u.slug = 'comsats-university-islamabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'comsats-university-islamabad-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'comsats-university-islamabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Wah Campus', 'comsats-university-islamabad-wah-campus', 'Wah Cantt', 'Punjab', false, true
from public.universities u where u.slug = 'comsats-university-islamabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Vehari Campus', 'comsats-university-islamabad-vehari-campus', 'Vehari', 'Punjab', false, true
from public.universities u where u.slug = 'comsats-university-islamabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sahiwal Campus', 'comsats-university-islamabad-sahiwal-campus', 'Sahiwal', 'Punjab', false, true
from public.universities u where u.slug = 'comsats-university-islamabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'continental-medical-college-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'continental-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'dawood-university-of-engineering-and-technology-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'dawood-university-of-engineering-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'dha-suffa-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'dha-suffa-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'DHA City Campus', 'dha-suffa-university-dha-city-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'dha-suffa-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'dow-university-of-health-sciences-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'dow-university-of-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Ojha Campus', 'dow-university-of-health-sciences-ojha-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'dow-university-of-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'emerson-university-multan-main-campus', 'Multan', 'Punjab', true, true
from public.universities u where u.slug = 'emerson-university-multan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad', 'faisalabad-medical-university-faisalabad', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'faisalabad-medical-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'fast-national-university-of-computer-and-emerging-sciences-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'fast-national-university-of-computer-and-emerging-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'fast-national-university-of-computer-and-emerging-sciences-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'fast-national-university-of-computer-and-emerging-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'fast-national-university-of-computer-and-emerging-sciences-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'fast-national-university-of-computer-and-emerging-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'fast-national-university-of-computer-and-emerging-sciences-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'fast-national-university-of-computer-and-emerging-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Chiniot Campus', 'fast-national-university-of-computer-and-emerging-sciences-chiniot-campus', 'Chiniot', 'Punjab', false, true
from public.universities u where u.slug = 'fast-national-university-of-computer-and-emerging-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan Campus', 'fast-national-university-of-computer-and-emerging-sciences-multan-campus', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'fast-national-university-of-computer-and-emerging-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'fata-university-main-campus', 'Kohat', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'fata-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'fatima-jinnah-medical-university-main-campus', 'Lahore', 'Punjab', true, true
from public.universities u where u.slug = 'fatima-jinnah-medical-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'fatima-jinnah-medical-university-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'fatima-jinnah-medical-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi Campus', 'fatima-jinnah-women-university-rawalpindi-campus', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'fatima-jinnah-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'fazaia-medical-college-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'fazaia-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'federal-urdu-university-of-arts-sciences-and-technology-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'federal-urdu-university-of-arts-sciences-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'federal-urdu-university-of-arts-sciences-and-technology-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'federal-urdu-university-of-arts-sciences-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'fmh-college-of-medicine-and-dentistry-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'fmh-college-of-medicine-and-dentistry'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'forman-christian-college-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'forman-christian-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'foundation-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'foundation-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi Campus', 'foundation-university-rawalpindi-campus', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'foundation-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'foundation-university-medical-college-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'foundation-university-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Abbottabad', 'frontier-medical-college-abbottabad', 'Abbottabad', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'frontier-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'gandhara-university-main-campus', 'Peshawar', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'gandhara-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'ghazi-university-main-campus', 'Dera Ghazi Khan', 'Punjab', true, true
from public.universities u where u.slug = 'ghazi-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'ghulam-ishaq-khan-institute-of-engineering-sciences-and-technology-main-campus', 'Swabi', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'ghulam-ishaq-khan-institute-of-engineering-sciences-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gujranwala Campus', 'gift-university-gujranwala-campus', 'Gujranwala', 'Punjab', false, true
from public.universities u where u.slug = 'gift-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Dera Ismail Khan', 'gomal-medical-college-dera-ismail-khan', 'Dera Ismail Khan', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'gomal-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Dera Ismail Khan Campus', 'gomal-university-dera-ismail-khan-campus', 'Dera Ismail Khan', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'gomal-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Tank Campus', 'gomal-university-tank-campus', 'Tank', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'gomal-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sialkot', 'government-college-university-sialkot', 'Sialkot', 'Punjab', false, true
from public.universities u where u.slug = 'government-college-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'government-college-university-faisalabad-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'government-college-university-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Chiniot Campus', 'government-college-university-faisalabad-chiniot-campus', 'Chiniot', 'Punjab', false, true
from public.universities u where u.slug = 'government-college-university-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Layyah Campus', 'government-college-university-faisalabad-layyah-campus', 'Layyah', 'Punjab', false, true
from public.universities u where u.slug = 'government-college-university-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sahiwal Campus', 'government-college-university-faisalabad-sahiwal-campus', 'Sahiwal', 'Punjab', false, true
from public.universities u where u.slug = 'government-college-university-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Hafizabad Campus', 'government-college-university-faisalabad-hafizabad-campus', 'Hafizabad', 'Punjab', false, true
from public.universities u where u.slug = 'government-college-university-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'government-college-university-hyderabad-main-campus', 'Hyderabad', 'Sindh', true, true
from public.universities u where u.slug = 'government-college-university-hyderabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'government-college-university-lahore-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'government-college-university-lahore'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bahawalpur', 'government-college-women-university-bahawalpur', 'Bahawalpur', 'Punjab', false, true
from public.universities u where u.slug = 'government-college-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'government-college-women-university-faisalabad-main-campus', 'Faisalabad', 'Punjab', true, true
from public.universities u where u.slug = 'government-college-women-university-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'government-college-women-university-sialkot-main-campus', 'Sialkot', 'Punjab', true, true
from public.universities u where u.slug = 'government-college-women-university-sialkot'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'government-sadiq-college-women-university-main-campus', 'Bahawalpur', 'Punjab', true, true
from public.universities u where u.slug = 'government-sadiq-college-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'greenwich-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'greenwich-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gujranwala', 'gujranwala-medical-college-gujranwala', 'Gujranwala', 'Punjab', false, true
from public.universities u where u.slug = 'gujranwala-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'habib-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'habib-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'hajvery-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'hajvery-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'hamdard-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'hamdard-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'hamdard-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'hamdard-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mansehra Campus', 'hazara-university-mansehra-campus', 'Mansehra', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'hazara-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Battagram Campus', 'hazara-university-battagram-campus', null, null, false, true
from public.universities u where u.slug = 'hazara-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'health-services-academy-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'health-services-academy'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'hitec-university-main-campus', 'Taxila', 'Punjab', true, true
from public.universities u where u.slug = 'hitec-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'ibadat-international-university-main-campus', 'Islamabad', 'Islamabad Capital Territory', true, true
from public.universities u where u.slug = 'ibadat-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'ilma-university-main-campus', 'Karachi', 'Sindh', true, true
from public.universities u where u.slug = 'ilma-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad', 'independent-medical-college-faisalabad', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'independent-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'indus-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'indus-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'North Campus', 'indus-university-north-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'indus-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'institute-of-business-administration-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'institute-of-business-administration'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'institute-of-business-and-technology-main-campus', 'Karachi', 'Sindh', true, true
from public.universities u where u.slug = 'institute-of-business-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'institute-of-business-management-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'institute-of-business-management'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'institute-of-cost-and-management-accountants-of-pakistan-main-campus', 'Karachi', 'Sindh', true, true
from public.universities u where u.slug = 'institute-of-cost-and-management-accountants-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'institute-of-space-technology-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'institute-of-space-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kahuta Campus', 'institute-of-space-technology-kahuta-campus', 'Kahuta', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'institute-of-space-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'institute-of-space-technology-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'institute-of-space-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'international-islamic-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'international-islamic-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'iqra-national-university-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'iqra-national-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Swat Campus', 'iqra-national-university-swat-campus', 'Swat', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'iqra-national-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'iqra-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'iqra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'iqra-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'iqra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Hyderabad Campus', 'iqra-university-hyderabad-campus', 'Hyderabad', 'Sindh', false, true
from public.universities u where u.slug = 'iqra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'North Campus Karachi', 'iqra-university-north-campus-karachi', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'iqra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gulshan Campus Karachi', 'iqra-university-gulshan-campus-karachi', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'iqra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Chak Shahzad Campus Islamabad', 'iqra-university-chak-shahzad-campus-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'iqra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sialkot', 'islam-medical-college-sialkot', 'Sialkot', 'Punjab', false, true
from public.universities u where u.slug = 'islam-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'islamabad-medical-and-dental-college-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'islamabad-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'islamabad-university-of-health-sciences-and-emerging-technologies-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'islamabad-university-of-health-sciences-and-emerging-technologies'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sialkot Campus', 'islamabad-university-of-health-sciences-and-emerging-technologies-sialkot-campus', 'Sialkot', 'Punjab', false, true
from public.universities u where u.slug = 'islamabad-university-of-health-sciences-and-emerging-technologies'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'islamia-college-university-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'islamia-college-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bahawalpur Campus', 'islamia-university-of-bahawalpur-bahawalpur-campus', 'Bahawalpur', 'Punjab', false, true
from public.universities u where u.slug = 'islamia-university-of-bahawalpur'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rahim Yar Khan Campus', 'islamia-university-of-bahawalpur-rahim-yar-khan-campus', 'Rahim Yar Khan', 'Punjab', false, true
from public.universities u where u.slug = 'islamia-university-of-bahawalpur'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bahawalnagar Campus', 'islamia-university-of-bahawalpur-bahawalnagar-campus', 'Bahawalnagar', 'Punjab', false, true
from public.universities u where u.slug = 'islamia-university-of-bahawalpur'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Hyderabad Campus', 'isra-university-hyderabad-campus', 'Hyderabad', 'Sindh', false, true
from public.universities u where u.slug = 'isra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'isra-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'isra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'isra-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'isra-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'jinnah-sindh-medical-university-main-campus', 'Karachi', 'Sindh', true, true
from public.universities u where u.slug = 'jinnah-sindh-medical-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar', 'kabir-medical-college-peshawar', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'kabir-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'karachi-institute-of-economics-and-technology-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'karachi-institute-of-economics-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Ahsanabad Campus', 'karachi-institute-of-economics-and-technology-ahsanabad-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'karachi-institute-of-economics-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gilgit Campus', 'karakoram-international-university-gilgit-campus', 'Gilgit', 'Gilgit-Baltistan', false, true
from public.universities u where u.slug = 'karakoram-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Hunza Campus', 'karakoram-international-university-hunza-campus', 'Hunza', 'Gilgit-Baltistan', false, true
from public.universities u where u.slug = 'karakoram-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Diamer Campus', 'karakoram-international-university-diamer-campus', 'Diamer', 'Gilgit-Baltistan', false, true
from public.universities u where u.slug = 'karakoram-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Ghizer Campus', 'karakoram-international-university-ghizer-campus', 'Ghizer', 'Gilgit-Baltistan', false, true
from public.universities u where u.slug = 'karakoram-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rahim Yar Khan Campus', 'khwaja-fareed-university-of-engineering-and-information-technology-rahim-yar-khan-campus', 'Rahim Yar Khan', 'Punjab', false, true
from public.universities u where u.slug = 'khwaja-fareed-university-of-engineering-and-information-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar', 'khyber-girls-medical-college-peshawar', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'khyber-girls-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'king-edward-medical-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'king-edward-medical-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'kinnaird-college-for-women-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'kinnaird-college-for-women'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kohat Campus', 'kohat-university-of-science-and-technology-kohat-campus', 'Kohat', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'kohat-university-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Hangu Campus', 'kohat-university-of-science-and-technology-hangu-campus', 'Hangu', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'kohat-university-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'lahore-college-for-women-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'lahore-college-for-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Jhang Campus', 'lahore-college-for-women-university-jhang-campus', 'Jhang', 'Punjab', false, true
from public.universities u where u.slug = 'lahore-college-for-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'lahore-garrison-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'lahore-garrison-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'lahore-leads-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'lahore-leads-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'lahore-leads-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'lahore-leads-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'lahore-medical-and-dental-college-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'lahore-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'lahore-school-of-economics-main-campus', 'Lahore', 'Punjab', true, true
from public.universities u where u.slug = 'lahore-school-of-economics'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'lahore-university-of-biological-and-applied-sciences-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'lahore-university-of-biological-and-applied-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'lahore-university-of-management-sciences-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'lahore-university-of-management-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Uthal Campus', 'lasbela-university-of-agriculture-water-and-marine-sciences-uthal-campus', 'Uthal', 'Balochistan', false, true
from public.universities u where u.slug = 'lasbela-university-of-agriculture-water-and-marine-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Wadh Campus', 'lasbela-university-of-agriculture-water-and-marine-sciences-wadh-campus', 'Wadh', 'Balochistan', false, true
from public.universities u where u.slug = 'lasbela-university-of-agriculture-water-and-marine-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Dera Murad Jamali Campus', 'lasbela-university-of-agriculture-water-and-marine-sciences-dera-murad-jamali-campus', 'Dera Murad Jamali', 'Balochistan', false, true
from public.universities u where u.slug = 'lasbela-university-of-agriculture-water-and-marine-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'liaquat-university-of-medical-and-health-sciences-main-campus', 'Jamshoro', 'Sindh', true, true
from public.universities u where u.slug = 'liaquat-university-of-medical-and-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gujranwala', 'm-islam-medical-college-gujranwala', 'Gujranwala', 'Punjab', false, true
from public.universities u where u.slug = 'm-islam-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi', 'margalla-institute-of-health-sciences-rawalpindi', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'margalla-institute-of-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Jamshoro Campus', 'mehran-university-of-engineering-and-technology-jamshoro-campus', 'Jamshoro', 'Sindh', false, true
from public.universities u where u.slug = 'mehran-university-of-engineering-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Khairpur Campus', 'mehran-university-of-engineering-and-technology-khairpur-campus', 'Khairpur', 'Sindh', false, true
from public.universities u where u.slug = 'mehran-university-of-engineering-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'minhaj-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'minhaj-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mirpur Campus', 'mirpur-university-of-science-and-technology-mirpur-campus', 'Mirpur', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'mirpur-university-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mirpur', 'mirpur-university-of-science-and-technology-mirpur', 'Mirpur', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'mirpur-university-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Nerian Sharif Campus', 'mohi-ud-din-islamic-university-nerian-sharif-campus', 'Nerian Sharif', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'mohi-ud-din-islamic-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mirpur Campus', 'mohi-ud-din-islamic-university-mirpur-campus', 'Mirpur', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'mohi-ud-din-islamic-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mirpur', 'mohtarma-benazir-bhutto-shaheed-medical-college-mirpur', 'Mirpur', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'mohtarma-benazir-bhutto-shaheed-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan', 'multan-medical-and-dental-college-multan', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'multan-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan Campus', 'multan-university-of-science-and-technology-multan-campus', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'multan-university-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'national-college-of-arts-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'national-college-of-arts'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi Campus', 'national-college-of-arts-rawalpindi-campus', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'national-college-of-arts'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'national-college-of-business-administration-and-economics-main-campus', 'Lahore', 'Punjab', true, true
from public.universities u where u.slug = 'national-college-of-business-administration-and-economics'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'national-defence-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'national-defence-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'national-textile-university-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'national-textile-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'national-textile-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'national-textile-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'national-university-of-medical-sciences-main-campus', 'Rawalpindi', 'Punjab', true, true
from public.universities u where u.slug = 'national-university-of-medical-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'national-university-of-modern-languages-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'national-university-of-modern-languages-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'national-university-of-modern-languages-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'national-university-of-modern-languages-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan Campus', 'national-university-of-modern-languages-multan-campus', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'national-university-of-modern-languages-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Hyderabad Campus', 'national-university-of-modern-languages-hyderabad-campus', 'Hyderabad', 'Sindh', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Quetta Campus', 'national-university-of-modern-languages-quetta-campus', 'Quetta', 'Balochistan', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi Campus', 'national-university-of-modern-languages-rawalpindi-campus', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mirpur Campus', 'national-university-of-modern-languages-mirpur-campus', 'Mirpur', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'national-university-of-modern-languages'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'national-university-of-pakistan-main-campus', 'Islamabad', 'Islamabad Capital Territory', true, true
from public.universities u where u.slug = 'national-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'national-university-of-sciences-and-technology-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'national-university-of-sciences-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Quetta Campus', 'national-university-of-sciences-and-technology-quetta-campus', 'Quetta', 'Balochistan', false, true
from public.universities u where u.slug = 'national-university-of-sciences-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'national-university-of-sciences-and-technology-school-of-civil-and-environmental-engineering-main-campus', 'Islamabad', 'Islamabad Capital Territory', true, true
from public.universities u where u.slug = 'national-university-of-sciences-and-technology-school-of-civil-and-environmental-engineering'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'national-university-of-technology-main-campus', 'Islamabad', 'Islamabad Capital Territory', true, true
from public.universities u where u.slug = 'national-university-of-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'nazeer-hussain-university-main-campus', 'Karachi', 'Sindh', true, true
from public.universities u where u.slug = 'nazeer-hussain-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'ned-university-of-engineering-and-technology-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'ned-university-of-engineering-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mithi Campus', 'ned-university-of-engineering-and-technology-mithi-campus', 'Mithi', 'Sindh', false, true
from public.universities u where u.slug = 'ned-university-of-engineering-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan', 'nishtar-medical-university-multan', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'nishtar-medical-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar', 'northwest-school-of-medicine-peshawar', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'northwest-school-of-medicine'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'pak-austria-fachhochschule-institute-of-applied-sciences-and-technology-main-campus', 'Haripur', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'pak-austria-fachhochschule-institute-of-applied-sciences-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar', 'pakistan-institute-of-community-ophthalmology-peshawar', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'pakistan-institute-of-community-ophthalmology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'pakistan-institute-of-development-economics-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'pakistan-institute-of-development-economics'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Nilore Campus', 'pakistan-institute-of-engineering-and-applied-sciences-nilore-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'pakistan-institute-of-engineering-and-applied-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'pakistan-institute-of-fashion-and-design-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'pakistan-institute-of-fashion-and-design'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'pakistan-institute-of-medical-sciences-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'pakistan-institute-of-medical-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'pakistan-marine-academy-main-campus', 'Karachi', 'Sindh', true, true
from public.universities u where u.slug = 'pakistan-marine-academy'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'people-s-university-of-medical-and-health-sciences-for-women-main-campus', 'Nawabshah', 'Sindh', true, true
from public.universities u where u.slug = 'people-s-university-of-medical-and-health-sciences-for-women'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar', 'peshawar-medical-college-peshawar', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'peshawar-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi Campus', 'pir-mehr-ali-shah-arid-agriculture-university-rawalpindi-campus', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'pir-mehr-ali-shah-arid-agriculture-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Attock Campus', 'pir-mehr-ali-shah-arid-agriculture-university-attock-campus', 'Attock', 'Punjab', false, true
from public.universities u where u.slug = 'pir-mehr-ali-shah-arid-agriculture-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalakot', 'poonch-medical-college-rawalakot', 'Rawalakot', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'poonch-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'preston-institute-of-management-sciences-and-technology-main-campus', 'Karachi', 'Sindh', true, true
from public.universities u where u.slug = 'preston-institute-of-management-sciences-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kohat Campus', 'preston-university-kohat-campus', 'Kohat', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'preston-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'preston-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'preston-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'preston-university-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'preston-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'preston-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'preston-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'punjab-tianjin-university-of-technology-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'punjab-tianjin-university-of-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'qarshi-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'qarshi-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Nawabshah Campus', 'quaid-i-awam-university-of-engineering-science-and-technology-nawabshah-campus', 'Shaheed Benazirabad', 'Sindh', false, true
from public.universities u where u.slug = 'quaid-i-awam-university-of-engineering-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Larkana Campus', 'quaid-i-awam-university-of-engineering-science-and-technology-larkana-campus', 'Larkana', 'Sindh', false, true
from public.universities u where u.slug = 'quaid-i-awam-university-of-engineering-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'quaid-i-azam-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'quaid-i-azam-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad School of Management Sciences', 'quaid-i-azam-university-islamabad-school-of-management-sciences', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'quaid-i-azam-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Quetta', 'quetta-institute-of-medical-sciences-quetta', 'Quetta', 'Balochistan', false, true
from public.universities u where u.slug = 'quetta-institute-of-medical-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Dera Ismail Khan Campus', 'qurtuba-university-of-science-and-information-technology-dera-ismail-khan-campus', 'Dera Ismail Khan', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'qurtuba-university-of-science-and-information-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'qurtuba-university-of-science-and-information-technology-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'qurtuba-university-of-science-and-information-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'rashid-latif-medical-college-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'rashid-latif-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'rawal-institute-of-health-sciences-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'rawal-institute-of-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi', 'rawalpindi-medical-college-rawalpindi', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'rawalpindi-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'rawalpindi-medical-university-main-campus', 'Rawalpindi', 'Punjab', true, true
from public.universities u where u.slug = 'rawalpindi-medical-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi Campus', 'rawalpindi-women-university-rawalpindi-campus', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'rawalpindi-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi', 'rawalpindi-women-university-rawalpindi', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'rawalpindi-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar', 'rehman-college-of-rehabilitation-sciences-peshawar', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'rehman-college-of-rehabilitation-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'riphah-international-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'riphah-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'riphah-international-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'riphah-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'riphah-international-university-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'riphah-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sahiwal Campus', 'riphah-international-university-sahiwal-campus', 'Sahiwal', 'Punjab', false, true
from public.universities u where u.slug = 'riphah-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'riphah-international-university-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'riphah-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gujranwala Campus', 'riphah-international-university-gujranwala-campus', 'Gujranwala', 'Punjab', false, true
from public.universities u where u.slug = 'riphah-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gulberg Greens Campus', 'riphah-international-university-gulberg-greens-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'riphah-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Malakand Campus', 'riphah-international-university-malakand-campus', 'Malakand', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'riphah-international-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Narowal', 'sahara-medical-college-narowal', 'Narowal', 'Punjab', false, true
from public.universities u where u.slug = 'sahara-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Quetta Campus', 'sardar-bahadur-khan-women-university-quetta-campus', 'Quetta', 'Balochistan', false, true
from public.universities u where u.slug = 'sardar-bahadur-khan-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Pishin Campus', 'sardar-bahadur-khan-women-university-pishin-campus', 'Pishin', 'Balochistan', false, true
from public.universities u where u.slug = 'sardar-bahadur-khan-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Noshki Campus', 'sardar-bahadur-khan-women-university-noshki-campus', 'Noshki', 'Balochistan', false, true
from public.universities u where u.slug = 'sardar-bahadur-khan-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Khuzdar Campus', 'sardar-bahadur-khan-women-university-khuzdar-campus', 'Khuzdar', 'Balochistan', false, true
from public.universities u where u.slug = 'sardar-bahadur-khan-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'sarhad-university-of-science-and-information-technology-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'sarhad-university-of-science-and-information-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'sarhad-university-of-science-and-information-technology-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'sarhad-university-of-science-and-information-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Khairpur Campus', 'shah-abdul-latif-university-khairpur-campus', 'Khairpur', 'Sindh', false, true
from public.universities u where u.slug = 'shah-abdul-latif-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Ghotki Campus', 'shah-abdul-latif-university-ghotki-campus', 'Ghotki', 'Sindh', false, true
from public.universities u where u.slug = 'shah-abdul-latif-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Shahdadkot Campus', 'shah-abdul-latif-university-shahdadkot-campus', 'Shahdadkot', 'Sindh', false, true
from public.universities u where u.slug = 'shah-abdul-latif-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bhitshah', 'shah-abdul-latif-university-bhitshah', 'Bhitshah', 'Sindh', false, true
from public.universities u where u.slug = 'shah-abdul-latif-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Shaheed Benazirabad Campus', 'shaheed-benazir-bhutto-university-shaheed-benazirabad-campus', 'Shaheed Benazirabad', 'Sindh', false, true
from public.universities u where u.slug = 'shaheed-benazir-bhutto-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Naushahro Feroze Campus', 'shaheed-benazir-bhutto-university-naushahro-feroze-campus', 'Naushahro Feroze', 'Sindh', false, true
from public.universities u where u.slug = 'shaheed-benazir-bhutto-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sakrand Campus', 'shaheed-benazir-bhutto-university-of-veterinary-and-animal-sciences-sakrand-campus', 'Sakrand', 'Sindh', false, true
from public.universities u where u.slug = 'shaheed-benazir-bhutto-university-of-veterinary-and-animal-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sheringal Campus', 'shaheed-benazir-bhutto-university-sheringal-sheringal-campus', 'Sheringal', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'shaheed-benazir-bhutto-university-sheringal'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Wari Campus', 'shaheed-benazir-bhutto-university-sheringal-wari-campus', 'Wari', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'shaheed-benazir-bhutto-university-sheringal'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'shaheed-benazir-bhutto-women-university-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'shaheed-benazir-bhutto-women-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'shaheed-mohtarma-benazir-bhutto-medical-university-main-campus', 'Larkana', 'Sindh', true, true
from public.universities u where u.slug = 'shaheed-mohtarma-benazir-bhutto-medical-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Hyderabad Campus', 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology-hyderabad-campus', 'Hyderabad', 'Sindh', false, true
from public.universities u where u.slug = 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Larkana Campus', 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology-larkana-campus', 'Larkana', 'Sindh', false, true
from public.universities u where u.slug = 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gharo Campus', 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology-gharo-campus', 'Gharo', 'Sindh', false, true
from public.universities u where u.slug = 'shaheed-zulfiqar-ali-bhutto-institute-of-science-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Shikarpur Campus', 'shaikh-ayaz-university-shikarpur-campus', 'Shikarpur', 'Sindh', false, true
from public.universities u where u.slug = 'shaikh-ayaz-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'shalamar-medical-and-dental-college-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'shalamar-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'sharif-medical-and-dental-college-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'sharif-medical-and-dental-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'shifa-college-of-medicine-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'shifa-college-of-medicine'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'shifa-tameer-e-millat-university-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'shifa-tameer-e-millat-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sialkot', 'sialkot-medical-college-sialkot', 'Sialkot', 'Punjab', false, true
from public.universities u where u.slug = 'sialkot-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Tandojam Campus', 'sindh-agriculture-university-tandojam-campus', 'Tandojam', 'Sindh', false, true
from public.universities u where u.slug = 'sindh-agriculture-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Umerkot Campus', 'sindh-agriculture-university-umerkot-campus', 'Umerkot', 'Sindh', false, true
from public.universities u where u.slug = 'sindh-agriculture-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'sindh-institute-of-medical-sciences-main-campus', 'Karachi', 'Sindh', true, true
from public.universities u where u.slug = 'sindh-institute-of-medical-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'sindh-madressatul-islam-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'sindh-madressatul-islam-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'sir-syed-case-institute-of-technology-main-campus', 'Islamabad', 'Islamabad Capital Territory', true, true
from public.universities u where u.slug = 'sir-syed-case-institute-of-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Narowal', 'sughra-shafi-medical-complex-narowal', 'Narowal', 'Punjab', false, true
from public.universities u where u.slug = 'sughra-shafi-medical-complex'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sukkur Campus', 'sukkur-iba-university-sukkur-campus', 'Sukkur', 'Sindh', false, true
from public.universities u where u.slug = 'sukkur-iba-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Khairpur Campus', 'sukkur-iba-university-khairpur-campus', 'Khairpur', 'Sindh', false, true
from public.universities u where u.slug = 'sukkur-iba-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kandhkot Campus', 'sukkur-iba-university-kandhkot-campus', 'Kandhkot', 'Sindh', false, true
from public.universities u where u.slug = 'sukkur-iba-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'superior-university-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'superior-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Okara Campus', 'superior-university-okara-campus', 'Okara', 'Punjab', false, true
from public.universities u where u.slug = 'superior-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sargodha Campus', 'superior-university-sargodha-campus', 'Sargodha', 'Punjab', false, true
from public.universities u where u.slug = 'superior-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rahim Yar Khan Campus', 'superior-university-rahim-yar-khan-campus', 'Rahim Yar Khan', 'Punjab', false, true
from public.universities u where u.slug = 'superior-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'superior-university-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'superior-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Layyah Campus', 'superior-university-layyah-campus', 'Layyah', 'Punjab', false, true
from public.universities u where u.slug = 'superior-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Swat', 'swat-medical-college-swat', 'Swat', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'swat-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'the-university-of-faisalabad-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'the-university-of-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'the-university-of-faisalabad-main-campus', 'Faisalabad', 'Punjab', true, true
from public.universities u where u.slug = 'the-university-of-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'university-of-agriculture-faisalabad-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-agriculture-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Toba Tek Singh Campus', 'university-of-agriculture-faisalabad-toba-tek-singh-campus', 'Toba Tek Singh', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-agriculture-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Depalpur Campus', 'university-of-agriculture-faisalabad-depalpur-campus', 'Depalpur', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-agriculture-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Burewala Campus', 'university-of-agriculture-faisalabad-burewala-campus', 'Burewala', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-agriculture-faisalabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-attock-main-campus', 'Attock', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-attock'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-azad-jammu-and-kashmir-main-campus', 'Muzaffarabad', 'Azad Jammu and Kashmir', true, true
from public.universities u where u.slug = 'university-of-azad-jammu-and-kashmir'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-bahawalnagar-main-campus', 'Bahawalnagar', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-bahawalnagar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Quetta Campus', 'university-of-balochistan-quetta-campus', 'Quetta', 'Balochistan', false, true
from public.universities u where u.slug = 'university-of-balochistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mastung Campus', 'university-of-balochistan-mastung-campus', 'Mastung', 'Balochistan', false, true
from public.universities u where u.slug = 'university-of-balochistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kharan Campus', 'university-of-balochistan-kharan-campus', 'Kharan', 'Balochistan', false, true
from public.universities u where u.slug = 'university-of-balochistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-baltistan-main-campus', 'Baltistan', 'Gilgit-Baltistan', true, true
from public.universities u where u.slug = 'university-of-baltistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-bhakkar-main-campus', 'Bhakkar', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-bhakkar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-buner-main-campus', 'Buner', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'university-of-buner'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'university-of-central-punjab-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-central-punjab'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Chakwal Campus', 'university-of-chakwal-chakwal-campus', 'Chakwal', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-chakwal'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-chakwal-main-campus', 'Chakwal', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-chakwal'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gujrat Campus', 'university-of-chenab-gujrat-campus', 'Gujrat', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-chenab'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore', 'university-of-child-health-sciences-lahore', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-child-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Chitral Campus', 'university-of-chitral-chitral-campus', 'Chitral', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-chitral'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-dera-ghazi-khan-main-campus', 'Dera Ghazi Khan', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-dera-ghazi-khan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'university-of-education-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-education'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Attock Campus', 'university-of-education-attock-campus', 'Attock', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-education'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'university-of-education-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-education'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Dera Ghazi Khan Campus', 'university-of-education-dera-ghazi-khan-campus', 'Dera Ghazi Khan', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-education'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Joharabad Campus', 'university-of-education-joharabad-campus', 'Joharabad', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-education'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan Campus', 'university-of-education-multan-campus', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-education'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Vehari Campus', 'university-of-education-vehari-campus', 'Vehari', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-education'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'university-of-engineering-and-technology-lahore-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-lahore'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kala Shah Kaku Campus', 'university-of-engineering-and-technology-lahore-kala-shah-kaku-campus', 'Kala Shah Kaku', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-lahore'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'university-of-engineering-and-technology-lahore-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-lahore'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rachna College Gujranwala', 'university-of-engineering-and-technology-lahore-rachna-college-gujranwala', 'Gujranwala', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-lahore'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Narowal Campus', 'university-of-engineering-and-technology-lahore-narowal-campus', 'Narowal', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-lahore'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mardan Campus', 'university-of-engineering-and-technology-mardan-mardan-campus', 'Mardan', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-mardan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'university-of-engineering-and-technology-peshawar-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-peshawar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Abbottabad Campus', 'university-of-engineering-and-technology-peshawar-abbottabad-campus', 'Abbottabad', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-peshawar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bannu Campus', 'university-of-engineering-and-technology-peshawar-bannu-campus', 'Bannu', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-peshawar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Jalozai Campus', 'university-of-engineering-and-technology-peshawar-jalozai-campus', 'Jalozai', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-peshawar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kohat Campus', 'university-of-engineering-and-technology-peshawar-kohat-campus', 'Kohat', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-peshawar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Taxila Campus', 'university-of-engineering-and-technology-taxila-taxila-campus', 'Taxila', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-engineering-and-technology-taxila'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gujrat Campus', 'university-of-gujrat-gujrat-campus', 'Gujrat', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-gujrat'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mandi Bahauddin Campus', 'university-of-gujrat-mandi-bahauddin-campus', 'Mandi Bahauddin', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-gujrat'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-gujrat-main-campus', 'Gujrat', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-gujrat'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-gwadar-main-campus', 'Gwadar', 'Balochistan', true, true
from public.universities u where u.slug = 'university-of-gwadar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-hafizabad-main-campus', 'Hafizabad', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-hafizabad'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Haripur Campus', 'university-of-haripur-haripur-campus', 'Haripur', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-haripur'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'university-of-health-sciences-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-health-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'university-of-home-economics-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-home-economics'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Jhang Campus', 'university-of-jhang-jhang-campus', 'Jhang', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-jhang'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-jhang-main-campus', 'Jhang', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-jhang'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-jhelum-main-campus', 'Jhelum', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-jhelum'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-kamalia-main-campus', 'Kamalia', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-kamalia'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'university-of-karachi-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'university-of-karachi'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-kasur-main-campus', 'Kasur', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-kasur'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-khanewal-main-campus', 'Khanewal', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-khanewal'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-kharian-main-campus', 'Kharian', 'Khyber Pakhtunkhwa', true, false
from public.universities u where u.slug = 'university-of-kharian'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-kotli-azad-jammu-and-kashmir-main-campus', 'Kotli', 'Azad Jammu and Kashmir', true, true
from public.universities u where u.slug = 'university-of-kotli-azad-jammu-and-kashmir'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'university-of-lahore-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-lahore'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sargodha Campus', 'university-of-lahore-sargodha-campus', 'Sargodha', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-lahore'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-lakki-marwat-main-campus', 'Lakki Marwat', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'university-of-lakki-marwat'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-larkano-main-campus', 'Larkana', 'Sindh', true, true
from public.universities u where u.slug = 'university-of-larkano'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Layyah Campus', 'university-of-layyah-layyah-campus', 'Layyah', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-layyah'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-lodhran-main-campus', 'Lodhran', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-lodhran'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-loralai-main-campus', 'Loralai', 'Balochistan', true, true
from public.universities u where u.slug = 'university-of-loralai'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-makran-main-campus', 'Makran', 'Balochistan', true, true
from public.universities u where u.slug = 'university-of-makran'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Malakand Campus', 'university-of-malakand-malakand-campus', 'Malakand', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-malakand'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Batkhela Campus', 'university-of-malakand-batkhela-campus', 'Batkhela', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-malakand'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'university-of-management-and-technology-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-management-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sialkot Campus', 'university-of-management-and-technology-sialkot-campus', 'Sialkot', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-management-and-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mianwali Campus', 'university-of-mianwali-mianwali-campus', 'Mianwali', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-mianwali'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-mianwali-main-campus', 'Mianwali', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-mianwali'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-mirpurkhas-main-campus', 'Mirpurkhas', 'Sindh', true, true
from public.universities u where u.slug = 'university-of-mirpurkhas'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-murree-main-campus', null, null, true, false
from public.universities u where u.slug = 'university-of-murree'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-muzaffargarh-main-campus', 'Muzaffargarh', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-muzaffargarh'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Narowal Campus', 'university-of-narowal-narowal-campus', 'Narowal', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-narowal'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-narowal-main-campus', 'Narowal', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-narowal'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Athmuqam', 'university-of-neelum-athmuqam', 'Athmuqam', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'university-of-neelum'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Okara Campus', 'university-of-okara-okara-campus', 'Okara', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-okara'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-okara-main-campus', 'Okara', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-okara'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-pakpattan-main-campus', 'Pakpattan', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-pakpattan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'university-of-peshawar-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-peshawar'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalakot Campus', 'university-of-poonch-rawalakot-campus', 'Rawalakot', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'university-of-poonch'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Kahuta Haveli Campus', 'university-of-poonch-kahuta-haveli-campus', 'Kahuta', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'university-of-poonch'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalakot', 'university-of-poonch-rawalakot', 'Rawalakot', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'university-of-poonch'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-rahim-yar-khan-main-campus', 'Rahim Yar Khan', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-rahim-yar-khan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-rajanpur-main-campus', 'Rajanpur', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-rajanpur'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-rawalpindi-main-campus', 'Rawalpindi', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-rawalpindi'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-sahiwal-main-campus', 'Sahiwal', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-sahiwal'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sargodha Campus', 'university-of-sargodha-sargodha-campus', 'Sargodha', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-sargodha'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bhakkar Campus', 'university-of-sargodha-bhakkar-campus', 'Bhakkar', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-sargodha'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mianwali Campus', 'university-of-sargodha-mianwali-campus', 'Mianwali', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-sargodha'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-sargodha-main-campus', 'Sargodha', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-sargodha'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Shangla Campus', 'university-of-shangla-shangla-campus', 'Shangla', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-shangla'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-sheikhupura-main-campus', 'Sheikhupura', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-sheikhupura'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sialkot Campus', 'university-of-sialkot-sialkot-campus', 'Sialkot', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-sialkot'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Jamshoro Campus', 'university-of-sindh-jamshoro-campus', 'Jamshoro', 'Sindh', false, true
from public.universities u where u.slug = 'university-of-sindh'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mirpur Khas Campus', 'university-of-sindh-mirpur-khas-campus', 'Mirpur Khas', 'Sindh', false, true
from public.universities u where u.slug = 'university-of-sindh'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Badin Campus', 'university-of-sindh-badin-campus', 'Badin', 'Sindh', false, true
from public.universities u where u.slug = 'university-of-sindh'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Dadu Campus', 'university-of-sindh-dadu-campus', 'Dadu', 'Sindh', false, true
from public.universities u where u.slug = 'university-of-sindh'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bhitshah Campus', 'university-of-sufism-and-modern-sciences-bhitshah-campus', 'Bhitshah', 'Sindh', false, true
from public.universities u where u.slug = 'university-of-sufism-and-modern-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Swabi Campus', 'university-of-swabi-swabi-campus', 'Swabi', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-swabi'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Swat Campus', 'university-of-swat-swat-campus', 'Swat', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-swat'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-taunsa-main-campus', 'Taunsa', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-taunsa'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-taxila-main-campus', 'Taxila', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-taxila'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Nowshera Campus', 'university-of-technology-nowshera-campus', 'Nowshera', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mardan', 'university-of-technology-mardan', 'Mardan', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-technology'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Turbat Campus', 'university-of-turbat-turbat-campus', 'Turbat', 'Balochistan', false, true
from public.universities u where u.slug = 'university-of-turbat'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gwadar Campus', 'university-of-turbat-gwadar-campus', 'Gwadar', 'Balochistan', false, true
from public.universities u where u.slug = 'university-of-turbat'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Panjgur Campus', 'university-of-turbat-panjgur-campus', 'Panjgur', 'Balochistan', false, true
from public.universities u where u.slug = 'university-of-turbat'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-vehari-main-campus', 'Vehari', 'Punjab', true, false
from public.universities u where u.slug = 'university-of-vehari'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'university-of-veterinary-and-animal-sciences-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-veterinary-and-animal-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Pattoki Campus', 'university-of-veterinary-and-animal-sciences-pattoki-campus', 'Pattoki', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-veterinary-and-animal-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Jhang Campus', 'university-of-veterinary-and-animal-sciences-jhang-campus', 'Jhang', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-veterinary-and-animal-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Narowal Campus', 'university-of-veterinary-and-animal-sciences-narowal-campus', 'Narowal', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-veterinary-and-animal-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Wah Campus', 'university-of-wah-wah-campus', 'Wah Cantt', 'Punjab', false, true
from public.universities u where u.slug = 'university-of-wah'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-wah-main-campus', 'Wah Cantt', 'Punjab', true, true
from public.universities u where u.slug = 'university-of-wah'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Mardan Campus', 'university-of-women-mardan-mardan-campus', 'Mardan', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'university-of-women-mardan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'university-of-zhob-main-campus', 'Zhob', 'Balochistan', true, true
from public.universities u where u.slug = 'university-of-zhob'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Lahore Campus', 'virtual-university-of-pakistan-lahore-campus', 'Lahore', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad Campus', 'virtual-university-of-pakistan-islamabad-campus', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Rawalpindi Campus', 'virtual-university-of-pakistan-rawalpindi-campus', 'Rawalpindi', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Dera Ghazi Khan Campus', 'virtual-university-of-pakistan-dera-ghazi-khan-campus', 'Dera Ghazi Khan', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Faisalabad Campus', 'virtual-university-of-pakistan-faisalabad-campus', 'Faisalabad', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Gujranwala Campus', 'virtual-university-of-pakistan-gujranwala-campus', 'Gujranwala', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Multan Campus', 'virtual-university-of-pakistan-multan-campus', 'Multan', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sahiwal Campus', 'virtual-university-of-pakistan-sahiwal-campus', 'Sahiwal', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Badin Campus', 'virtual-university-of-pakistan-badin-campus', 'Badin', 'Sindh', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Ghotki Campus', 'virtual-university-of-pakistan-ghotki-campus', 'Ghotki', 'Sindh', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'virtual-university-of-pakistan-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Pishin Campus', 'virtual-university-of-pakistan-pishin-campus', 'Pishin', 'Balochistan', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Peshawar Campus', 'virtual-university-of-pakistan-peshawar-campus', 'Peshawar', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Muzaffargarh Campus', 'virtual-university-of-pakistan-muzaffargarh-campus', 'Muzaffargarh', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Hyderabad Campus', 'virtual-university-of-pakistan-hyderabad-campus', 'Hyderabad', 'Sindh', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Jhelum Campus', 'virtual-university-of-pakistan-jhelum-campus', 'Jhelum', 'Punjab', false, true
from public.universities u where u.slug = 'virtual-university-of-pakistan'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Wah Cantt', 'wah-medical-college-wah-cantt', 'Wah Cantt', 'Punjab', false, true
from public.universities u where u.slug = 'wah-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Abbottabad', 'women-medical-college-abbottabad', 'Abbottabad', 'Khyber Pakhtunkhwa', false, true
from public.universities u where u.slug = 'women-medical-college'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'women-university-of-azad-jammu-and-kashmir-main-campus', 'Bagh', 'Azad Jammu and Kashmir', true, true
from public.universities u where u.slug = 'women-university-of-azad-jammu-and-kashmir'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Bagh', 'women-university-of-bagh-bagh', 'Bagh', 'Azad Jammu and Kashmir', false, true
from public.universities u where u.slug = 'women-university-of-bagh'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Main Campus', 'women-university-swabi-main-campus', 'Swabi', 'Khyber Pakhtunkhwa', true, true
from public.universities u where u.slug = 'women-university-swabi'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Islamabad', 'yusra-institute-of-pharmaceutical-sciences-islamabad', 'Islamabad', 'Islamabad Capital Territory', false, true
from public.universities u where u.slug = 'yusra-institute-of-pharmaceutical-sciences'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Karachi Campus', 'ziauddin-university-karachi-campus', 'Karachi', 'Sindh', false, true
from public.universities u where u.slug = 'ziauddin-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();
insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, 'Sukkur Campus', 'ziauddin-university-sukkur-campus', 'Sukkur', 'Sindh', false, true
from public.universities u where u.slug = 'ziauddin-university'
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();

-- 3. One community channel per campus ---------------------------------------
insert into public.channels (university_id, campus_id, slug, name, description, guidelines, banner_url, posting_policy, is_active)
select
  u.id,
  c.id,
  -- stable, shareable slug: <university-slug>-<campus-slug-tail>
  case
    when c.name = 'Main Campus' then u.slug
    else u.slug || '-' || regexp_replace(lower(c.name), '[^a-z0-9]+', '-', 'g')
  end,
  u.name || case when c.name = 'Main Campus' then '' else ' · ' || c.name end,
  coalesce(c.city, u.city, 'Pakistan') || ' · ' || u.name ||
    case when c.name = 'Main Campus' then '' else ' (' || c.name || ')' end,
  '1. Be decent. Disagree with ideas, not with people.
2. No doxxing — never post a real name, phone number, address, CNIC or screenshot of private chats.
3. No harassment, hate speech, threats or targeted bullying.
4. Confessions about specific people must not be identifiable.
5. No exam-paper leaks, admission fraud or academic-dishonesty services.
6. Reports are reviewed by moderators; repeat offenders lose access.',
  coalesce(u.banner_url, null),
  'members',
  c.is_active
from public.campuses c
join public.universities u on u.id = c.university_id
on conflict (campus_id) do update set
  name = excluded.name,
  description = excluded.description,
  guidelines = excluded.guidelines,
  is_active = excluded.is_active,
  updated_at = now();

commit;

