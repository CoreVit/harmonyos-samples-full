# HarmonyOS Samples Full Snapshot

This repository is a flattened working snapshot of the official HarmonyOS
`sample_in_harmonyos` code-workshop project and the independent Sample
repositories downloaded by its official scripts.

## Layout and provenance

- The code-workshop project remains at the repository root.
- Independent Sample repositories are stored as ordinary source directories
  under `submodules/`; nested Git metadata is intentionally not included.
- Original `LICENSE`, `OAT.xml`, README and attribution files are retained in
  the root project and individual Sample directories.
- The official source baseline for the root project is commit
  `bcc6b03e472a1e89daca5fca8526000e8fed4386`.

## Local build setup

The snapshot intentionally contains no personal signing material. After
cloning, sign the root project for your own development account and connected
device:

```powershell
devecocli auth login
devecocli signature generate --product default
```

Independent projects that are built from their own nested project root, such
as `submodules/MultiVideoApplication`, require the same signature-generation
step from that project directory.

Git LFS is required to download the complete image, audio and video resources:

```powershell
git lfs install
git lfs pull
```

Generated build outputs, dependency caches, IDE metadata and local signing
files are excluded from version control.
