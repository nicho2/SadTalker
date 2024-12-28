# Utiliser une image officielle NVIDIA avec CUDA 12.1 et Python 3.8
FROM nvidia/cuda:12.1.1-runtime-ubuntu20.04

# Désactiver les prompts interactifs pour debconf
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3-pip \
    python3.8-venv \
    git \
    ffmpeg \
    libgl1-mesa-glx \
    tzdata \
    && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier uniquement les fichiers et répertoires nécessaires dans le conteneur
COPY checkpoints /app/checkpoints
COPY gfpgan /app/gfpgan
COPY src /app/src
COPY pyproject.toml /app/pyproject.toml
COPY README.md /app/README.md
COPY *.py /app/
COPY start.sh /app/start.sh
COPY requirements.txt /app/requirements.txt

# Installer les dépendances avec pip et uv
RUN pip install --no-cache-dir uv


# Créer et configurer un environnement virtuel avec uv
RUN uv venv venv

# Ajouter l'index PyTorch officiel pour installer torch avec CUDA 12.1
RUN . venv/bin/activate && uv pip install torch==2.4.1+cu121 torchvision==0.19.1+cu121 torchaudio==2.4.1+cu121 --extra-index-url https://download.pytorch.org/whl/cu121  \
    && uv pip install -r requirements.txt && uv pip install TTS

# Modifier le fichier basicsr/data/degradations.py
RUN sed -i 's/from torchvision.transforms.functional_tensor import rgb_to_grayscale/from torchvision.transforms.functional import rgb_to_grayscale/' \
    venv/lib/python3.8/site-packages/basicsr/data/degradations.py

# Exposer un port si nécessaire pour l'application
EXPOSE 7860

CMD ["bash", "start.sh"]

