#!/usr/bin/env python3

import itertools
import os

LANGS = ["ita", "lij"]

num_lines = {}
for lang in LANGS:
    print(f"Collecting {lang} sentences… ")
    num_lines[lang] = 0
    with open(f"raw_mono/{lang}", "rt") as f:
        num_lines[lang] += sum(1 for _ in f)
max_lines = max(num_lines.values())

for lang in LANGS:
    print(f"Upsampling {lang} corpus…", flush=True)
    os.system(f"cp raw_mono/{lang} mono/{lang}.tmp")
    lines = num_lines[lang]
    with open(f"raw_mono/{lang}", "rt") as fin, open(f"mono/{lang}.tmp", "at") as fout:
        loop = itertools.cycle(fin)
        for line in loop:
            if lines >= max_lines or lines >= 1_250_000:
                break
            fout.write(line)
            lines += 1
    os.system(f"mv mono/{lang}.tmp mono/{lang}")

print(f"Combining all files…", flush=True)
files = " ".join(f"mono/{lang}" for lang in LANGS)
os.system(f"cat {files} | shuf > mono/multi")

os.system("spm_train --input=mono/multi --model_prefix=spm/multi.unigram.2k --vocab_size=2000 --character_coverage=0.9995 --model_type=unigram --input_sentence_size=5000000 --shuffle_input_sentence=true --split_digits=true")