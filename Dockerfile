# Copy this file and the two *-docker.txt files into the root of your pytorch fork.
# Official PyTorch 2.5.1 / CUDA 11.8 / cuDNN 9 development image.
# The digest was read from Docker Hub on 2026-10-14.
FROM pytorch/pytorch:2.5.1-cuda11.8-cudnn9-devel@sha256:676c7b7423d7e726b814b98cfd5b702e1b32016b2e0ef0270f6202a6c660c419

ENV PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    MPLBACKEND=Agg

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl git nano psmisc zip unzip libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements-docker.txt constraints-docker.txt /tmp/

# Keep the CUDA-enabled Torch supplied by the base image.
# OpenCV is headless, with a version compatible with NumPy 1.26.4.
RUN python -m pip install --no-cache-dir \
        --constraint /tmp/constraints-docker.txt \
        --requirement /tmp/requirements-docker.txt \
    && mkdir -p /opt/hsi-environment \
    && python -m pip freeze > /opt/hsi-environment/pip-freeze.txt

WORKDIR /workspace
CMD ["/bin/bash"]
