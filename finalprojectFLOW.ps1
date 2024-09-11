# Initialize student data
$global:students = @(
    @("Andi", "Teknik Informatika", 78),
    @("Lutfi", "Sistem Informasi", 83),
    @("Nadia", "Teknik Elektro", 88)
)
$minGrade = 80
$running = $true

# Function to display students with green headers and underlined text
function Display-Students {
    
    # Display headers in green
    Write-Host ("{0,-15}{1,-20}{2,-5}" -f "Nama", "Jurusan", "Nilai") -ForegroundColor Green
    Write-Host ("{0,-15}{1,-20}{2,-5}" -f "----", "-------", "-----") -ForegroundColor Green  # Underline the headers
    
    # Display student data normally
    foreach ($student in $students) {
        Write-Host ("{0,-15}{1,-20}{2,-5}" -f $student[0], $student[1], $student[2])
    }
}

# Function to analyze graduation with green statistics and underlined text
function Analyze-Graduation {
    $passed = 0
    $failed = 0
    foreach ($student in $students) {
        if ($student[2] -ge $minGrade) {
            $passed++
        } else {
            $failed++
        }
    }
    
    # Display statistics in table form with proper alignment
    Write-Host ""
    Write-Host "Statistik Kelulusan:" 
    Write-Host ""
    
    # Make sure both headers and data have consistent column widths
    Write-Host ("{0,-25}{1,-25}" -f "Jumlah Mahasiswa Lulus", "Jumlah Mahasiswa Tidak Lulus") -ForegroundColor Green
    Write-Host ("{0,-25}{1,-25}" -f "----------------------", "----------------------------") -ForegroundColor Green  # Underline
    
    # Align the numbers properly below the headers
    Write-Host ("{0,22}{1,31}" -f $passed, $failed)
    Write-Host ""
}


# Function to add a new student with confirmation
function Add-Student {
    # Collecting data from user input
    $name = Read-Host "Masukkan Nama Mahasiswa Baru"
    $jurusan = Read-Host "Masukkan Jurusan Mahasiswa Baru"
    
    # Ensure the input for grade is a number
    $nilai = [int](Read-Host "Masukkan Nilai Mahasiswa Baru")

    # Create a new student record
    $newStudent = @($name, $jurusan, $nilai)

    # Append the new student data to the $students array
    $global:students += ,$newStudent
}

# Function to update an existing student
function Update-Student {
    $name = Read-Host "Masukkan Nama Mahasiswa yang ingin dicari"
    $found = $false
    for ($i = 0; $i -lt $students.Count; $i++) {
        if ($students[$i][0] -eq $name) {
            
            # Display student data before updating
            Write-Host "Informasi Mahasiswa:"
            Write-Host ""
            Write-Host ("{0,-15}{1,-20}{2,-5}" -f "Nama", "Jurusan", "Nilai") -ForegroundColor Green
            Write-Host ("{0,-15}{1,-20}{2,-5}" -f "----", "-------", "-----") -ForegroundColor Green 
            Write-Host ("{0,-15}{1,-20}{2,-5}" -f $students[$i][0], $students[$i][1], $students[$i][2])
            Write-Host ""
            
            # Ask for confirmation before updating
            $confirm = Read-Host "Apakah ingin mengganti jurusan mahasiswa ini? (Y/N)"
            if ($confirm -eq "Y") {
                $newJurusan = Read-Host "Masukkan Jurusan Baru"
                $students[$i][1] = $newJurusan
                Write-Host "Jurusan telah diupdate. Data Mahasiswa terbaru:"
                Write-Host ""
                Display-Students
                Write-Host ""
                Analyze-Graduation
                Write-Host ""
                $found = $true
                break
            } else {
                Write-Host "Update dibatalkan."
            }
        }
    }
    if (-not $found) {
        Write-Host "Mahasiswa tidak ditemukan."
    }
}

# Main Loop Following Flowchart Logic
while ($running) {
    # Show the student data
    Write-Host "Data Mahasiswa Awal :"
    Write-Host ""
    Display-Students
    Write-Host ""
    Analyze-Graduation

    # Loop until both operations (update and add) are answered with N
    $updateAnsweredN = $false
    $addAnsweredN = $false

    while (-not $updateAnsweredN -or -not $addAnsweredN) {
        # Ask if user wants to update a student's data
        $updateStudent = Read-Host "Apakah ingin mengupdate data Mahasiswa? (Y/N)"
        if ($updateStudent -eq "Y") {
            Update-Student
            $updateAnsweredN = $false
        } else {
            $updateAnsweredN = $true
        }

        # Ask if user wants to add a new student
        $addStudent = Read-Host "Apakah ingin menambahkan data Mahasiswa Baru? (Y/N)"
        if ($addStudent -eq "Y") {
            Add-Student
            Analyze-Graduation
            Write-Host ""
            Write-Host "Data Mahasiswa setelah penambahan data baru:"
            Write-Host ""
            Display-Students
            Write-Host ""
            $addAnsweredN = $false
        } else {
            $addAnsweredN = $true
        }
    }

    Write-Host "Keluar dari program..."
    $running = $false
}
