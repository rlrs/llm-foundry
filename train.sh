#!/bin/bash

cd /project/scripts/train
composer train.py yamls/pretrain/mpt-1b.yaml train_loader.dataset.split=train_small eval_loader.dataset.split=val_small