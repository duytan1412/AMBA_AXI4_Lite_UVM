param(
    [ValidateSet('vcs','xcelium')]
    [string]$Simulator = 'xcelium',
    [string[]]$Tests = @('base_test', 'axi_error_test', 'axi_burst_like_test')
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo
New-Item -ItemType Directory -Force -Path 'sim_results' | Out-Null

foreach ($test in $Tests) {
    $log = "sim_results/$test.log"
    Write-Host "Running $test with $Simulator"
    if ($Simulator -eq 'xcelium') {
        xrun -sv -uvm -f filelist.f "+UVM_TESTNAME=$test" -l $log
    } else {
        vcs -full64 -sverilog -ntb_opts uvm-1.2 -f filelist.f -l "sim_results/${test}_compile.log"
        ./simv "+UVM_TESTNAME=$test" | Tee-Object -FilePath $log
    }
}
