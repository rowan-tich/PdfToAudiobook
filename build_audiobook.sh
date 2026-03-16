#!/bin/bash

# Define the input file
INPUT_PDF=${1:-"book.pdf"}
TOTAL_START=$SECONDS

# Function to format seconds into MM:SS
format_time() {
    local T=$1
    local M=$((T/60))
    local S=$((T%60))
    printf "%02d:%02d" $M $S
}

echo "=========================================="
echo "🎧 Starting Audiobook Creation Pipeline"
echo "=========================================="

# 1. Extraction
STEP_START=$SECONDS
echo "Step 1/4: Extracting text from $INPUT_PDF..."
python extract_text.py "$INPUT_PDF"
if [ $? -ne 0 ]; then echo "❌ Extraction failed!"; exit 1; fi
echo "   ⏱️  Step 1 took: $(format_time $(($SECONDS - STEP_START)))"

# 2. Classification
STEP_START=$SECONDS
echo "Step 2/4: Classifying text blocks..."
python classify.py
if [ $? -ne 0 ]; then echo "❌ Classification failed!"; exit 1; fi
echo "   ⏱️  Step 2 took: $(format_time $(($SECONDS - STEP_START)))"

# 3. Text-to-Speech
STEP_START=$SECONDS
echo "Step 3/4: Generating audio files (This may take a while)..."
python tts.py
if [ $? -ne 0 ]; then echo "❌ TTS failed!"; exit 1; fi
echo "   ⏱️  Step 3 took: $(format_time $(($SECONDS - STEP_START)))"

# 4. Join Audio
STEP_START=$SECONDS
echo "Step 4/4: Merging audio into final file..."
python join_audios.py
if [ $? -ne 0 ]; then echo "❌ Audio merging failed!"; exit 1; fi
echo "   ⏱️  Step 4 took: $(format_time $(($SECONDS - STEP_START)))"

echo "=========================================="
echo "✅ Done! Your audiobook is ready."
echo "🏁 Total execution time: $(format_time $(($SECONDS - TOTAL_START)))"
echo "=========================================="