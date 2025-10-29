#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --cpus-per-task=72
#SBATCH --time=5:00:00
#SBATCH --job-name=bench
#SBATCH --export=NONE

module load likwid
unset SLURM_EXPORT_ENV

mkdir -p results

filename1=scaling_2000_20000.txt
filename2=scaling_20000_2000.txt
filename3=scaling_1000_400000.txt
echo "threads performanceCG performancePCG" > results/$filename1
echo "threads performanceCG performancePCG" > results/$filename2
echo "threads performanceCG performancePCG" > results/$filename3

for threads in {1..72}; do
    export OMP_NUM_THREADS=$threads

    RESULT1=$(srun --cpu-freq=2200000-2200000:performance likwid-pin -c N:0-$((threads-1)) ./perf 2000 20000 \
              | grep -E "Performance (CG|PCG)" | awk -F'=' '{print $2}' | awk '{print $1}' | paste -sd ' ')
    echo $threads $RESULT1 >> results/$filename1

    RESULT2=$(srun --cpu-freq=2200000-2200000:performance likwid-pin -c N:0-$((threads-1)) ./perf 20000 2000 \
              | grep -E "Performance (CG|PCG)" | awk -F'=' '{print $2}' | awk '{print $1}' | paste -sd ' ')
    echo $threads $RESULT2 >> results/$filename2

    RESULT3=$(srun --cpu-freq=2200000-2200000:performance likwid-pin -c N:0-$((threads-1)) ./perf 1000 400000 \
              | grep -E "Performance (CG|PCG)" | awk -F'=' '{print $2}' | awk '{print $1}' | paste -sd ' ')
    echo $threads $RESULT3 >> results/$filename3
done
