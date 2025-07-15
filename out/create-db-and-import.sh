#!/bin/bash

# This script creates and populates a SQLite database from the Hokkien dictionary CSV files.

# Step 1: Create a new (or clear an existing) SQLite database file
echo "Creating database file: kautian.db"
> kautian.db

# Step 2: Prepare temporary CSV files by removing the header row from each original file.
echo "Preparing temporary data files for import..."
tail -n +2 ./詞目.csv > temp_entries.csv
tail -n +2 ./義項.csv > temp_meanings.csv
tail -n +2 ./例句.csv > temp_examples.csv
tail -n +2 ./異用字.csv > temp_variant_characters.csv
tail -n +2 ./又唸作.csv > temp_alternative_pronunciations.csv
tail -n +2 ./俗唸作.csv > temp_colloquial_pronunciations.csv
tail -n +2 ./合音唸作.csv > temp_contractions.csv
tail -n +2 ./詞目tuì詞目近義.csv > temp_entry_synonyms.csv
tail -n +2 ./詞目tuì詞目反義.csv > temp_entry_antonyms.csv
tail -n +2 ./義項tuì義項近義.csv > temp_meaning_synonyms.csv
tail -n +2 ./義項tuì義項反義.csv > temp_meaning_antonyms.csv
tail -n +2 ./義項tuì詞目近義.csv > temp_meaning_to_entry_synonyms.csv
tail -n +2 ./義項tuì詞目反義.csv > temp_meaning_to_entry_antonyms.csv
tail -n +2 ./語音差異.csv > temp_phonetic_differences.csv
tail -n +2 ./詞彙比較.csv > temp_dialect_comparison.csv
tail -n +2 ./姓.csv > temp_surnames.csv
tail -n +2 ./名.csv > temp_given_names.csv
tail -n +2 ./漢字羅馬字對應.csv > temp_char_to_romanization.csv
tail -n +2 ./羅馬字清單.csv > temp_romanization_syllables.csv

# Step 3: Define schema and import data using a 'here document'
echo "Defining schema and importing data..."
sqlite3 kautian.db <<'EOF'

-- Enable foreign key support for data integrity
PRAGMA foreign_keys = ON;

-- Table for main entries from 詞目.csv
CREATE TABLE entries (
    id INTEGER PRIMARY KEY,
    type TEXT,
    hanzi TEXT NOT NULL,
    romanization TEXT,
    category TEXT,
    audio_file TEXT
);

-- Table for meanings from 義項.csv
CREATE TABLE meanings (
    entry_id INTEGER,
    id INTEGER PRIMARY KEY,
    part_of_speech TEXT,
    explanation TEXT,
    FOREIGN KEY (entry_id) REFERENCES entries(id)
);

-- Table for example sentences from 例句.csv
CREATE TABLE examples (
    entry_id INTEGER,
    meaning_id INTEGER,
    sequence INTEGER,
    hanzi TEXT,
    romanization TEXT,
    mandarin_translation TEXT,
    audio_file TEXT,
    PRIMARY KEY (meaning_id, sequence),
    FOREIGN KEY (entry_id) REFERENCES entries(id),
    FOREIGN KEY (meaning_id) REFERENCES meanings(id)
);

-- Table for variant characters (異用字) from 異用字.csv
CREATE TABLE variant_characters (
    entry_id INTEGER,
    original_hanzi TEXT,
    variant_hanzi TEXT,
    PRIMARY KEY (entry_id, variant_hanzi),
    FOREIGN KEY (entry_id) REFERENCES entries(id)
);

-- Table for alternative pronunciations (又唸作) from 又唸作.csv
CREATE TABLE alternative_pronunciations (
    entry_id INTEGER,
    hanzi TEXT,
    romanization TEXT,
    PRIMARY KEY (entry_id, romanization),
    FOREIGN KEY (entry_id) REFERENCES entries(id)
);

-- Table for colloquial pronunciations (俗唸作) from 俗唸作.csv
CREATE TABLE colloquial_pronunciations (
    entry_id INTEGER,
    hanzi TEXT,
    romanization TEXT,
    PRIMARY KEY (entry_id, romanization),
    FOREIGN KEY (entry_id) REFERENCES entries(id)
);

-- Table for contracted pronunciations (合音唸作) from 合音唸作.csv
CREATE TABLE contractions (
    entry_id INTEGER,
    hanzi TEXT,
    romanization TEXT,
    PRIMARY KEY (entry_id, romanization),
    FOREIGN KEY (entry_id) REFERENCES entries(id)
);

-- Table for entry-to-entry synonyms from 詞目tuì詞目近義.csv
CREATE TABLE entry_synonyms (
    entry_id INTEGER,
    hanzi TEXT,
    synonym_id INTEGER,
    synonym_hanzi TEXT,
    PRIMARY KEY (entry_id, synonym_id),
    FOREIGN KEY (entry_id) REFERENCES entries(id),
    FOREIGN KEY (synonym_id) REFERENCES entries(id)
);

-- Table for entry-to-entry antonyms from 詞目tuì詞目反義.csv
CREATE TABLE entry_antonyms (
    entry_id INTEGER,
    hanzi TEXT,
    antonym_id INTEGER,
    antonym_hanzi TEXT,
    PRIMARY KEY (entry_id, antonym_id),
    FOREIGN KEY (entry_id) REFERENCES entries(id),
    FOREIGN KEY (antonym_id) REFERENCES entries(id)
);

-- Table for meaning-to-meaning synonyms from 義項tuì義項近義.csv
CREATE TABLE meaning_synonyms (
    meaning_id INTEGER,
    hanzi TEXT,
    explanation TEXT,
    synonym_meaning_id INTEGER,
    synonym_hanzi TEXT,
    synonym_explanation TEXT,
    PRIMARY KEY (meaning_id, synonym_meaning_id),
    FOREIGN KEY (meaning_id) REFERENCES meanings(id),
    FOREIGN KEY (synonym_meaning_id) REFERENCES meanings(id)
);

-- Table for meaning-to-meaning antonyms from 義項tuì義項反義.csv
CREATE TABLE meaning_antonyms (
    meaning_id INTEGER,
    hanzi TEXT,
    explanation TEXT,
    antonym_meaning_id INTEGER,
    antonym_hanzi TEXT,
    antonym_explanation TEXT,
    PRIMARY KEY (meaning_id, antonym_meaning_id),
    FOREIGN KEY (meaning_id) REFERENCES meanings(id),
    FOREIGN KEY (antonym_meaning_id) REFERENCES meanings(id)
);

-- Table for meaning-to-entry synonyms from 義項tuì詞目近義.csv
CREATE TABLE meaning_to_entry_synonyms (
    meaning_id INTEGER,
    hanzi TEXT,
    explanation TEXT,
    synonym_entry_id INTEGER,
    synonym_hanzi TEXT,
    PRIMARY KEY (meaning_id, synonym_entry_id),
    FOREIGN KEY (meaning_id) REFERENCES meanings(id),
    FOREIGN KEY (synonym_entry_id) REFERENCES entries(id)
);

-- Table for meaning-to-entry antonyms from 義項tuì詞目反義.csv
CREATE TABLE meaning_to_entry_antonyms (
    meaning_id INTEGER,
    hanzi TEXT,
    explanation TEXT,
    antonym_entry_id INTEGER,
    antonym_hanzi TEXT,
    PRIMARY KEY (meaning_id, antonym_entry_id),
    FOREIGN KEY (meaning_id) REFERENCES meanings(id),
    FOREIGN KEY (antonym_entry_id) REFERENCES entries(id)
);

-- Table for phonetic differences from 語音差異.csv
CREATE TABLE phonetic_differences (
    entry_id INTEGER PRIMARY KEY,
    hanzi TEXT,
    lu_gang_quan TEXT,
    san_xia_quan TEXT,
    taipei_quan TEXT,
    yi_lan_zhang TEXT,
    tai_nan_mix TEXT,
    gao_xiong_mix TEXT,
    jin_men_quan TEXT,
    ma_gong_quan TEXT,
    xin_zhu_quan TEXT,
    tai_zhong_zhang TEXT,
    FOREIGN KEY (entry_id) REFERENCES entries(id)
);

-- Table for dialect comparison from 詞彙比較.csv
CREATE TABLE dialect_comparison (
    mandarin_id INTEGER,
    mandarin_term TEXT,
    accent TEXT,
    hokkien_hanzi TEXT,
    hokkien_romanization TEXT
);

-- Table for surnames from 姓.csv
CREATE TABLE surnames (
    hanzi TEXT,
    romanization TEXT,
    sequence INTEGER,
    type TEXT,
    PRIMARY KEY(hanzi, romanization)
);

-- Table for given names from 名.csv
CREATE TABLE given_names (
    hanzi TEXT,
    romanization TEXT,
    sequence INTEGER,
    type TEXT,
    PRIMARY KEY(hanzi, romanization)
);

-- Table for hanzi-romanization mapping from 漢字羅馬字對應.csv
CREATE TABLE char_to_romanization (
    hanzi TEXT,
    romanization TEXT,
    source TEXT,
    PRIMARY KEY(hanzi, romanization)
);

-- Table for romanization syllables from 羅馬字清單.csv
CREATE TABLE romanization_syllables (
    romanization TEXT PRIMARY KEY,
    source TEXT
);


-- Set mode to CSV for importing
.mode csv

-- Import data from temporary files
.import temp_entries.csv entries
.import temp_meanings.csv meanings
.import temp_examples.csv examples
.import temp_variant_characters.csv variant_characters
.import temp_alternative_pronunciations.csv alternative_pronunciations
.import temp_colloquial_pronunciations.csv colloquial_pronunciations
.import temp_contractions.csv contractions
.import temp_entry_synonyms.csv entry_synonyms
.import temp_entry_antonyms.csv entry_antonyms
.import temp_meaning_synonyms.csv meaning_synonyms
.import temp_meaning_antonyms.csv meaning_antonyms
.import temp_meaning_to_entry_synonyms.csv meaning_to_entry_synonyms
.import temp_meaning_to_entry_antonyms.csv meaning_to_entry_antonyms
.import temp_phonetic_differences.csv phonetic_differences
.import temp_dialect_comparison.csv dialect_comparison
.import temp_surnames.csv surnames
.import temp_given_names.csv given_names
.import temp_char_to_romanization.csv char_to_romanization
.import temp_romanization_syllables.csv romanization_syllables

EOF

# Step 4: Clean up temporary files
echo "Cleaning up temporary files..."
rm temp_*.csv

echo "Database 'kautian.db' created and populated successfully."