#!/bin/sh
#$BATCH --workdir /work/gr-fe/kostya/MtDnaFromExomeData/body/2Derived/MtDnaStat
#SBATCH --job-name=MtDnafromBam
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --time=60:00:00
#SBATCH --mem=10gb
#SBATCH --output=MtDnaFromBam.%J.out
#SBATCH --error=MtDnaFromBam.%J.err

# Load all modules required
module load gcc/7.4.0
module load samtools/1.9

# Directories
OutputDir=/work/gr-fe/kostya/MtDnaFromExomeData/body/2Derived/MtDnaStat

for i in 0 1 2 3 4 5 6 7
do

if [[ "$i" -eq 0 ]] # space after the opening square bracked and space before the closing square bracket!!!
then
Title=SepsisNI
BamDir=/work/gr-fe/archive/sample_repository/Sepsis/NI/BAMS

elif [[ "$i" -eq 1 ]]
then
Title=Sepsis
BamDir=/work/gr-fe/archive/sample_repository/Sepsis/BAM

elif [[ "$i" -eq 2 ]]
then
Title=Hiv_SHCS392exomes  # SHCS392exomes Truseq setpoint Viral load study
BamDir=/work/gr-fe/archive/sample_repository/SHCS392exomes/BAMS

elif [[ "$i" -eq 3 ]]
then
Title=Hiv_BroadNeutBroadNeut  # SureSelect V5 Production of broadly neutralizing antibodies
BamDir=/work/gr-fe/archive/sample_repository/BroadNeut/BAMS/BroadNeut

elif [[ "$i" -eq 4 ]]
then
Title=Hiv_BroadNeutColumbia  # SureSelect V5 Production of broadly neutralizing antibodies
BamDir=/work/gr-fe/archive/sample_repository/BroadNeut/BAMS/Columbia

elif [[ "$i" -eq 5 ]]
then
Title=Hiv_V_SC # V_SC SureSelect V5 HIV super controller
BamDir=/work/gr-fe/archive/sample_repository/HIV_SC/BAM

elif [[ "$i" -eq 6 ]]
then
Title=Hiv_HIV_VNP # HIV_VNP SureSelect V4 HIV viral non-progressors
BamDir=/work/gr-fe/archive/sample_repository/HIV_VNP/BAM

elif [[ "$i" -eq 7 ]]
then
Title=Hiv_SystemsX # SystemsX IDT Xgen exome research panel 1.0 determinants of viral reservoir size & decay rate
BamDir=/work/gr-fe/archive/sample_repository/SystemsX/BAMS
fi

myfilenames=`ls $BamDir/*.bam  | grep -v samtools.`  #extansion is  .bam but do not contain 'samtools.' as in /work/gr-fe/archive/sample_repository/BroadNeut/BAMS/Columbia/samtools.586.5433.tmp.0000.bam
for eachfile in $myfilenames
 do
  NameOfFile=$(echo $eachfile | awk '{gsub(/.*\//, "", $0)} 1')  # This should set NameOfFile to the output of awk (filename without the path).
  samtools idxstats $BamDir/$NameOfFile > $OutputDir/$Title.$NameOfFile.idxstats
  samtools flagstat $BamDir/$NameOfFile > $OutputDir/$Title.$NameOfFile.flagstat
  samtools depth -a -r MT:1-16569 $BamDir/$NameOfFile > $OutputDir/$Title.$NameOfFile.depth
 done
done

## HEADER: script walks along several directories with bam files obtained after Exome Sequencing and extracts info about mtDNA reads
## many bam files belong to different exome capture kids and obtained / mapped with different pipelines and thus this test is pilot - to see abundance of mtDNA reads
## also this script is naive and consequitive (not parallel) and it takes ~ 50 hours to run
## INPUTS: bam files in many directories inside /work/gr-fe/archive/sample_repository/
## OUTPUTS: three types of iles (idxstats, flagstat, depth) for each bam file in the directory: /work/gr-fe/kostya/MtDnaFromExomeData/body/2Derived/MtDnaStat
# cd /work/gr-fe/kostya/MtDnaFromExomeData/body/2Derived/MtDnaStat
# ls | wc -l # 3069


## Transfer data to my laptop (to work with R)
## cd  # go home at laptop
## scp -r popadin@helvetios.epfl.ch:/work/gr-fe/kostya/MtDnaFromExomeData/body/2Derived/MtDnaStat .  # it will copie the whole folder MtDnaStat
## Rstudio: MtDnaStatAnalysis.01.R, MtDnaStatAnalysis.02.R


