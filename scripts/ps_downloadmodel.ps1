# Définir les dossiers et URLs
$checkpointsFolder = "../checkpoints"
$gfpganWeightsFolder = "../gfpgan/weights"

# Créer les dossiers s'ils n'existent pas
if (!(Test-Path -Path $checkpointsFolder)) {
    New-Item -ItemType Directory -Path $checkpointsFolder -Force
}

if (!(Test-Path -Path $gfpganWeightsFolder)) {
    New-Item -ItemType Directory -Path $gfpganWeightsFolder -Force
}

# Définir les URLs et les chemins de destination
$filesToDownload = @(
    @{ Url = "https://github.com/OpenTalker/SadTalker/releases/download/v0.0.2-rc/mapping_00109-model.pth.tar"; Path = "$checkpointsFolder/mapping_00109-model.pth.tar" },
    @{ Url = "https://github.com/OpenTalker/SadTalker/releases/download/v0.0.2-rc/mapping_00229-model.pth.tar"; Path = "$checkpointsFolder/mapping_00229-model.pth.tar" },
    @{ Url = "https://github.com/OpenTalker/SadTalker/releases/download/v0.0.2-rc/SadTalker_V0.0.2_256.safetensors"; Path = "$checkpointsFolder/SadTalker_V0.0.2_256.safetensors" },
    @{ Url = "https://github.com/OpenTalker/SadTalker/releases/download/v0.0.2-rc/SadTalker_V0.0.2_512.safetensors"; Path = "$checkpointsFolder/SadTalker_V0.0.2_512.safetensors" },
    @{ Url = "https://github.com/xinntao/facexlib/releases/download/v0.1.0/alignment_WFLW_4HG.pth"; Path = "$gfpganWeightsFolder/alignment_WFLW_4HG.pth" },
    @{ Url = "https://github.com/xinntao/facexlib/releases/download/v0.1.0/detection_Resnet50_Final.pth"; Path = "$gfpganWeightsFolder/detection_Resnet50_Final.pth" },
    @{ Url = "https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.4.pth"; Path = "$gfpganWeightsFolder/GFPGANv1.4.pth" },
    @{ Url = "https://github.com/xinntao/facexlib/releases/download/v0.2.2/parsing_parsenet.pth"; Path = "$gfpganWeightsFolder/parsing_parsenet.pth" }
)

# Télécharger les fichiers si non présents
foreach ($file in $filesToDownload) {
    if (!(Test-Path -Path $file.Path)) {
        Write-Host "Téléchargement de $($file.Url) vers $($file.Path)..."
        Invoke-WebRequest -Uri $file.Url -OutFile $file.Path
        Write-Host "Téléchargement terminé : $($file.Path)"
    } else {
        Write-Host "Fichier déjà présent : $($file.Path)"
    }
}

Write-Host "Tous les fichiers ont été vérifiés et téléchargés si nécessaire."
