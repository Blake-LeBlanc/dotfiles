Add-Type -AssemblyName System.Windows.Forms

function Show-Form {
    $form = New-Object Windows.Forms.Form
    $form.Text = "Website URL"
    $form.Width = 480
    $form.Height = 700
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    $urlLabel = New-Object Windows.Forms.Label
    $urlLabel.Location = New-Object Drawing.Point(20, 20)
    $urlLabel.Size = New-Object Drawing.Size(420, 20)
    $urlLabel.Text = "Enter website URL:"
    $form.Controls.Add($urlLabel)

    $textBox = New-Object Windows.Forms.TextBox
    $textBox.Location = New-Object Drawing.Point(20, 40)
    $textBox.Size = New-Object Drawing.Size(420, 20)
    $form.Controls.Add($textBox)

    $fileTypesLabel = New-Object Windows.Forms.Label
    $fileTypesLabel.Location = New-Object Drawing.Point(20, 80)
    $fileTypesLabel.Size = New-Object Drawing.Size(420, 20)
    $fileTypesLabel.Text = "Enter file types (comma-separated):"
    $form.Controls.Add($fileTypesLabel)

    $fileTypesTextBox = New-Object Windows.Forms.TextBox
    $fileTypesTextBox.Location = New-Object Drawing.Point(20, 100)
    $fileTypesTextBox.Size = New-Object Drawing.Size(420, 20)
    $fileTypesTextBox.Text = ".xlsx,.zip"
    $form.Controls.Add($fileTypesTextBox)

    $button = New-Object Windows.Forms.Button
    $button.Location = New-Object Drawing.Point(20, 140)
    $button.Size = New-Object Drawing.Size(420, 40)
    $button.Text = "Get count of files to download"
    $form.Controls.Add($button)

    $statusLabel = New-Object Windows.Forms.Label
    $statusLabel.Location = New-Object Drawing.Point(20, 500)
    $statusLabel.Size = New-Object Drawing.Size(360, 20)
    $form.Controls.Add($statusLabel)

    $closeButton = New-Object Windows.Forms.Button
    $closeButton.Location = New-Object Drawing.Point(20, 230)
    $closeButton.Size = New-Object Drawing.Size(180, 30)
    $closeButton.Text = "Close"
    $closeButton.Visible = $false
    $form.Controls.Add($closeButton)

    $startOverButton = New-Object Windows.Forms.Button
    $startOverButton.Location = New-Object Drawing.Point(200, 230)
    $startOverButton.Size = New-Object Drawing.Size(180, 30)
    $startOverButton.Text = "Start Over"
    $startOverButton.Visible = $false
    $form.Controls.Add($startOverButton)

    $button.Add_Click({
        $url = $textBox.Text
        $fileTypes = $fileTypesTextBox.Text -split ","
        $form.Controls.Remove($button)
        $statusLabel.Text = "Finding files..."

        $response = Invoke-WebRequest -Uri $url
        $links = $response.Links | Where-Object { $_.href -match ($fileTypes -join "|") }
        $fileCount = $links.Count

        $statusLabel.Text = "Found $fileCount files. Do you want to proceed?"

        $yesButton = New-Object Windows.Forms.Button
        $yesButton.Location = New-Object Drawing.Point(20, 540)
        $yesButton.Size = New-Object Drawing.Size(180, 30)
        $yesButton.Text = "Yes"
        $form.Controls.Add($yesButton)

        $noButton = New-Object Windows.Forms.Button
        $noButton.Location = New-Object Drawing.Point(230, 540)
        $noButton.Size = New-Object Drawing.Size(180, 30)
        $noButton.Text = "No"
        $form.Controls.Add($noButton)

        # $listButton = New-Object Windows.Forms.Button
        # $listButton.Location = New-Object Drawing.Point(20, 520)
        # $listButton.Size = New-Object Drawing.Size(360, 30)
        # $listButton.Text = "View List of Files"
        # $form.Controls.Add($listButton)

        $fileListTextBox = New-Object Windows.Forms.TextBox
        $fileListTextBox.Multiline = $true
        $fileListTextBox.ScrollBars = "Vertical"
        $fileListTextBox.Location = New-Object Drawing.Point(20, 120)
        $fileListTextBox.Size = New-Object Drawing.Size(420, 360)
        $form.Controls.Add($fileListTextBox)

        foreach ($link in $links) {
            $fileListTextBox.AppendText("$($link.href)`r`n")
        }

        # $listButton.Add_Click({
        #     $fileListTextBox.Visible = !$fileListTextBox.Visible
        # })

        $yesButton.Add_Click({
            $form.Controls.Remove($yesButton)
            $form.Controls.Remove($noButton)
            # $form.Controls.Remove($listButton)
            $form.Controls.Remove($fileListTextBox)
            $statusLabel.Text = "Downloading files..."

            foreach ($link in $links) {
                $fileName = [System.IO.Path]::GetFileName($link.href)
                Invoke-WebRequest -Uri ($url + $link.href) -OutFile $fileName
                Write-Host "Downloaded: $($link.href)"
            }

            $statusLabel.Text = "Files downloaded."
            $closeButton.Visible = $true
            $startOverButton.Visible = $true
        })

        $noButton.Add_Click({
            $form.Controls.Remove($yesButton)
            $form.Controls.Remove($noButton)
            # $form.Controls.Remove($listButton)
            $form.Controls.Remove($fileListTextBox)
            $statusLabel.Text = "Canceled. Files not downloaded."
            $closeButton.Visible = $true
            $startOverButton.Visible = $true
        })
    })

    $closeButton.Add_Click({ $form.Close() })
    $startOverButton.Add_Click({ $form.Close(); Show-Form })

    $form.ShowDialog()
}

Show-Form
