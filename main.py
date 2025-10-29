import subprocess

# List of core counts you want to test
core_counts = [i for i in range(1, 19)]

for cores in core_counts:
    print(f"Running with {cores} cores...")
    cmd = [
        "srun",
        "--cpu-freq=2200000-2200000:performance",
        "likwid-pin",
        "-C", f"S0:0-{cores-1}",
        "./perf", "1000", "400000"
    ]
    subprocess.run(" ".join(cmd), shell=True)
