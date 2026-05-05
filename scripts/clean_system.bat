@echo off
cd /d "%~dp0"

echo ========================================
echo        Windows System Cleaner v2.0
echo ========================================
echo.

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Not running as administrator
    echo [TIP] Right-click and select "Run as administrator"
    echo.
)

echo [1/8] Cleaning system temp files
call :clean_dir "%windir%\Temp" "System Temp"

echo [2/8] Cleaning Prefetch cache
call :clean_dir "%windir%\Prefetch" "Prefetch"

echo [3/8] Cleaning user temp files
call :clean_dir "%userprofile%\AppData\Local\Temp" "User Temp"

echo [4/8] Cleaning Windows Update cache
call :clean_dir "%windir%\SoftwareDistribution\Download" "Update Cache"

echo [5/8] Cleaning Microsoft Edge cache
call :clean_edge_cache

echo [6/8] Cleaning crash dump files
call :clean_dir "%userprofile%\AppData\Local\CrashDumps" "Crash Dumps"

echo [7/8] Cleaning dev tool caches
call :clean_dir "%userprofile%\AppData\Local\npm-cache" "npm Cache"
call :clean_dir "%userprofile%\.cache\pip" "pip Cache"

echo [8/8] Cleaning Recycle Bin
rd /s /q "%systemdrive%\$Recycle.Bin" 2>nul
echo        Done: Recycle Bin

echo.
echo ========================================
echo           CLEANING COMPLETE!
echo ========================================
echo.
pause
exit /b

:clean_dir
set "target=%~1"
set "name=%~2"
if exist "%target%" (
    rd /s /q "%target%" 2>nul
    if exist "%target%" (
        echo        Failed: %name% ^(in use^)
    ) else (
        echo        Done: %name%
        md "%target%" 2>nul
    )
) else (
    echo        Empty: %name%
)
goto :eof

:clean_edge_cache
set "EDGE_BASE=%userprofile%\AppData\Local\Microsoft\Edge\User Data"
if exist "%EDGE_BASE%" (
    :: Clean Code Cache
    if exist "%EDGE_BASE%\Default\Code Cache" (
        rd /s /q "%EDGE_BASE%\Default\Code Cache" 2>nul
        echo        Done: Edge Code Cache
    )
    :: Clean GPU Cache
    if exist "%EDGE_BASE%\Default\GPUCache" (
        rd /s /q "%EDGE_BASE%\Default\GPUCache" 2>nul
        echo        Done: Edge GPU Cache
    )
    :: Clean Shader Cache
    if exist "%EDGE_BASE%\Default\ShaderCache" (
        rd /s /q "%EDGE_BASE%\Default\ShaderCache" 2>nul
        echo        Done: Edge Shader Cache
    )
    :: Clean Dawn caches
    if exist "%EDGE_BASE%\Default\DawnGraphiteCache" (
        rd /s /q "%EDGE_BASE%\Default\DawnGraphiteCache" 2>nul
        echo        Done: Edge DawnGraphiteCache
    )
    if exist "%EDGE_BASE%\Default\DawnWebGPUCache" (
        rd /s /q "%EDGE_BASE%\Default\DawnWebGPUCache" 2>nul
        echo        Done: Edge DawnWebGPUCache
    )
    :: Clean optimization guide
    if exist "%EDGE_BASE%\Default\optimization_guide_hint_cache_store" (
        rd /s /q "%EDGE_BASE%\Default\optimization_guide_hint_cache_store" 2>nul
        echo        Done: Edge optimization cache
    )
    :: Clean GrShaderCache
    if exist "%EDGE_BASE%\Default\GrShaderCache" (
        rd /s /q "%EDGE_BASE%\Default\GrShaderCache" 2>nul
        echo        Done: Edge GrShaderCache
    )
    if exist "%EDGE_BASE%\GrShaderCache" (
        rd /s /q "%EDGE_BASE%\GrShaderCache" 2>nul
        echo        Done: Edge GrShaderCache ^(root^)
    )
    :: Clean component_crx_cache
    if exist "%EDGE_BASE%\component_crx_cache" (
        rd /s /q "%EDGE_BASE%\component_crx_cache" 2>nul
        echo        Done: Edge component_crx_cache
    )
    :: Clean extensions_crx_cache
    if exist "%EDGE_BASE%\extensions_crx_cache" (
        rd /s /q "%EDGE_BASE%\extensions_crx_cache" 2>nul
        echo        Done: Edge extensions_crx_cache
    )
    if exist "%EDGE_BASE%\Default\Extension" (
        rd /s /q "%EDGE_BASE%\Default\Extension" 2>nul
        echo        Done: Edge Extension cache
    )
) else (
    echo        Empty: Microsoft Edge ^(not installed^)
)
goto :eof