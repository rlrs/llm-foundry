#!/bin/bash -l
#SBATCH --job-name=dfm   # Job name
#SBATCH --output=dfm.o%j # Name of stdout output file
#SBATCH --error=dfm.e%j  # Name of stderr error file
#SBATCH --partition=standard-g  # Partition (queue) name
#SBATCH --nodes=1               # Total number of nodes 
#SBATCH --ntasks-per-node=1     # 1 MPI rank per node, llm-foundry handles the rest
#SBATCH --gpus-per-node=8       # Allocate one gpu per MPI rank
#SBATCH --time=0-02:00:00       # Run time (d-hh:mm:ss)
#SBATCH --mail-type=all         # Send email at begin and end of job
#SBATCH --account=project_465000670  # Project for billing
#SBATCH --mail-user=rasmus.larsen@alexandra.dk

module load LUMI/22.08 partition/G
module load aws-ofi-rccl


export NCCL_SOCKET_IFNAME=hsn
export NCCL_NET_GDR_LEVEL=3
export NCCL_DEBUG=INFO
export MIOPEN_USER_DB_PATH=/tmp/${USER}-miopen-cache-${SLURM_JOB_ID}
export MIOPEN_CUSTOM_CACHE_DIR=${MIOPEN_USER_DB_PATH}
export CXI_FORK_SAFE=1
export CXI_FORK_SAFE_HP=1
export FI_CXI_DISABLE_CQ_HUGETLB=1
export SINGULARITYENV_LD_LIBRARY_PATH=/opt/ompi/lib:${EBROOTAWSMINOFIMINRCCL}/lib:/opt/cray/xpmem/2.4.4-2.3_9.1__gff0e1d9.shasta/lib64:${SINGULARITYENV_LD_LIBRARY_PATH}


srun singularity exec -c --rocm --bind llm-foundry:/project /project/project_465000670/rocm.sif bash /project/train.sh

