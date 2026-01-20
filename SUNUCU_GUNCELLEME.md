# Sunucuda Güncelleme Rehberi

## Sorun: Git Pull Hatası

Eğer `git pull` yaparken "Your local changes would be overwritten" hatası alıyorsanız:

### Çözüm 1: Local Değişiklikleri Stash Yap (Önerilen)

```bash
# Local değişiklikleri geçici olarak sakla
git stash

# Güncellemeleri çek
git pull origin project-docs

# Eğer stash'teki değişiklikleri geri almak isterseniz
# git stash pop
```

### Çözüm 2: Local Değişiklikleri Discard Et

Eğer local değişiklikleri kaybetmek istemiyorsanız:

```bash
# Local değişiklikleri geri al (DİKKAT: Değişiklikler kaybolur!)
git checkout -- deploy.sh

# Güncellemeleri çek
git pull origin project-docs
```

### Çözüm 3: Local Değişiklikleri Commit Et

Eğer local değişiklikleri korumak istiyorsanız:

```bash
# Local değişiklikleri commit et
git add deploy.sh
git commit -m "Local deploy.sh değişiklikleri"

# Güncellemeleri çek (merge gerekebilir)
git pull origin project-docs

# Eğer conflict olursa çöz ve commit et
```

## Hızlı Çözüm (Önerilen)

```bash
# 1. Local değişiklikleri stash yap
git stash

# 2. Güncellemeleri çek
git pull origin project-docs

# 3. Nginx script'ini çalıştırılabilir yap
chmod +x setup-nginx.sh

# 4. Nginx'i yapılandır
./setup-nginx.sh
```
