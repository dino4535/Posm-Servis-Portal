#!/bin/bash

# Sunucuda git pull yapmak için script
# Local değişiklikleri stash eder ve pull yapar

echo "=========================================="
echo "Git Pull İşlemi"
echo "=========================================="
echo ""

# 1. Local değişiklikleri kontrol et
echo "1. Local değişiklikler kontrol ediliyor..."
if [ -n "$(git status --porcelain)" ]; then
    echo "Local değişiklikler bulundu, stash ediliyor..."
    git stash push -m "Local değişiklikler - $(date +%Y-%m-%d_%H:%M:%S)"
    echo "✓ Local değişiklikler stash edildi"
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

# 3. Stash'lenmiş değişiklikleri kontrol et
echo "3. Stash durumu:"
git stash list | head -5
echo ""

echo "=========================================="
echo "İşlem Tamamlandı"
echo "=========================================="
echo ""
echo "Eğer stash'lenmiş değişiklikleri geri yüklemek isterseniz:"
echo "  git stash pop"
echo ""
