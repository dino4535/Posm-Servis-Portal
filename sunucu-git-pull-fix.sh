#!/bin/bash

# Sunucuda git pull yapmak için script (local değişiklikleri otomatik temizler)

echo "=========================================="
echo "Git Pull İşlemi (Local Değişiklikleri Temizle)"
echo "=========================================="
echo ""

# 1. Local değişiklikleri kontrol et
echo "1. Local değişiklikler kontrol ediliyor..."
if [ -n "$(git status --porcelain)" ]; then
    echo "Local değişiklikler bulundu:"
    git status --short
    echo ""
    echo "Local değişiklikler atılıyor (stash yerine discard)..."
    git checkout -- .
    git clean -fd
    echo "✓ Local değişiklikler temizlendi"
else
    echo "✓ Local değişiklik yok"
fi
echo ""

# 2. Git pull yap
echo "2. Git pull yapılıyor..."
git pull origin project-docs
if [ $? -eq 0 ]; then
    echo "✓ Git pull başarılı"
else
    echo "✗ Git pull başarısız"
    exit 1
fi
echo ""

echo "=========================================="
echo "İşlem Tamamlandı"
echo "=========================================="
