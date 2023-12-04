#!/bin/bash

mkdir -p raw_mono
mkdir -p mono
mkdir -p spm

# Extra monolingual data for Ligurian and Italian
wget https://downloads.wortschatz-leipzig.de/corpora/ita_wikipedia_2021_1M.tar.gz
tar xvf ita_wikipedia_2021_1M.tar.gz ita_wikipedia_2021_1M/ita_wikipedia_2021_1M-sentences.txt
mv ita_wikipedia_2021_1M/ita_wikipedia_2021_1M-sentences.txt raw_mono/ita
wget https://github.com/ConseggioLigure/normalized_ligurian_corpus/blob/master/monolingual/monolingual.txt --output-document raw_mono/lij

# Evaluation data
wget https://tinyurl.com/flores200dataset --output-document flores200.zip
tar xvf flores200.zip
cat flores200_dataset/dev/dev.ita_Latn >> raw_mono/ita
cat flores200_dataset/dev/dev.lij_Latn >> raw_mono/lij

# Seed data
for lang in ita lij; do wget https://github.com/ConseggioLigure/data/blob/main/seed/seed.${lang}; done
cat seed.ita >> raw_mono/ita
cat seed.lij >> raw_mono/lij
