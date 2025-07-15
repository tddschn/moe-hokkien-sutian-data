# MoE Hokkien Dictionary (Sutian) Data in Various Formats

- [MoE Hokkien Dictionary (Sutian) Data in Various Formats](#moe-hokkien-dictionary-sutian-data-in-various-formats)
  - [How to Use](#how-to-use)
  - [Screenshots](#screenshots)
  - [Software utilizing this sqlite db](#software-utilizing-this-sqlite-db)
  - [Related Projects](#related-projects)
  - [License and Attribution](#license-and-attribution)

This repository contains tools to process the data from the Ministry of Education's Hokkien Dictionary and convert it into a structured SQLite database.

Due to licensing restrictions on the source data, **this repository does not contain the derived data, which is the sqlite database itself, only the software to process it.**

Source: https://sutian.moe.edu.tw/zh-hant/siongkuantsuguan/

The `kautian.ods` is downloaded from the site above, direct link: https://sutian.moe.edu.tw/media/senn/ods/kautian.ods .

`kautian.xlsx` is converted from the ods file using cloudconvert.com .

The csv files in `out/` are exported from the xlsx file using `xlsx2csv_export_all_sheets.py kautian.xlsx out`.

The heart of the data pipeline is the `out/create-db-and-import.sh` script, which creates a SQLite database and imports the CSV files into it with proper schema that interlinks different tables with foreign keys - it generates the `out/kautian.db` file.

## How to Use

Clone this repo and run the database creation script from within the `out/` directory:

```bash
cd out/
./create-db-and-import.sh
```

This will generate the `kautian.db` SQLite database file.

## Screenshots

https://gg.teddysc.me/?g=5b955acd9fbe8c48130e9cd104b6ddab&a&c=2

<!-- Start Markdown -->
![kautian-data-3_base64.png](https://g.teddysc.me/tddschn/5b955acd9fbe8c48130e9cd104b6ddab/kautian-data-3_base64.png?b)
![kautian-data-1_base64.png](https://g.teddysc.me/tddschn/5b955acd9fbe8c48130e9cd104b6ddab/kautian-data-1_base64.png?b)
![kautian-data-2_base64.png](https://g.teddysc.me/tddschn/5b955acd9fbe8c48130e9cd104b6ddab/kautian-data-2_base64.png?b)
<!-- End Markdown -->


## Software utilizing this sqlite db

- My own Hokkien Sutian: https://gg.teddysc.me/sutian
- I have some scripts to query the db locally

## Related Projects


## License and Attribution

The data from the Ministry of Education is licensed under **Creative Commons Attribution-NonCommercial-NoDerivs 2.5 Taiwan (CC BY-NC-ND 2.5 TW)**. You can view the license here: [https://creativecommons.org/licenses/by-nc-nd/2.5/tw/](https://creativecommons.org/licenses/by-nc-nd/2.5/tw/)

The "No-Derivatives" clause of this license means that the SQLite database (`kautian.db`) and any modified CSV files are considered derivative works and **cannot be publicly distributed**.

The scripts and code in this repository, such as `create-db-and-import.sh`, are my own work and are licensed under the MIT License (see `LICENSE` file).