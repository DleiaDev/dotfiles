### Silicon
```bash
sudo dnf install -y \
  cmake \
  expat-devel fontconfig-devel libxcb-devel \
  freetype-devel libxml2-devel \
  harfbuzz
cargo install silicon
```

### GitHub
```bash
sudo dnf install -y gh
```

### LazyGit
```bash
sudo dnf copr enable -y totalfreak/lazygit && sudo dnf install -y lazygit
```

### LazyDocker
```bash
sudo dnf copr enable -y atim/lazydocker && sudo dnf install -y lazydocker
```
