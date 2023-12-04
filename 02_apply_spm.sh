#!/bin/bash

mkdir -p data_bin
mkdir -p tmp

cat seed.lij | spm_encode --model=spm/multi.unigram.2k.model --output_format=piece > tmp/train.lij
cat seed.ita | spm_encode --model=spm/multi.unigram.2k.model --output_format=piece > tmp/train.ita

cat flores200_dataset/dev/lij_Latn.dev | spm_encode --model=spm/multi.unigram.2k.model --output_format=piece > tmp/valid.lij
cat flores200_dataset/dev/ita_Latn.dev | spm_encode --model=spm/multi.unigram.2k.model --output_format=piece > tmp/valid.ita

cat flores200_dataset/devtest/lij_Latn.devtest | spm_encode --model=spm/multi.unigram.2k.model --output_format=piece > tmp/test.lij
cat flores200_dataset/devtest/ita_Latn.devtest | spm_encode --model=spm/multi.unigram.2k.model --output_format=piece > tmp/test.ita

cp flores200_dataset/devtest/ita_Latn.devtest devtest.ita
cp flores200_dataset/devtest/lij_Latn.devtest devtest.lij

fairseq-preprocess \
  --source-lang ita --target-lang lij \
  --trainpref tmp/train \
  --validpref tmp/valid \
  --testpref tmp/test \
  --thresholdtgt 0 \
  --thresholdsrc 0 \
  --joined-dictionary \
  --destdir data_bin

rm -r tmp