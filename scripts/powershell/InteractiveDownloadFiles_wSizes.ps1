Add-Type -AssemblyName System.Windows.Forms

function Show-Form {
    $form = New-Object Windows.Forms.Form
    $form.Text = "Website URL"
    $form.Width = 400
    $form.Height = 400
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    $urlLabel = New-Object Windows.Forms.Label
    $urlLabel.Location = New-Object Drawing.Point(20, 20)
    $urlLabel.Size = New-Object Drawing.Size(360, 20)
    $urlLabel.Text = "Enter website URL:"
    $form.Controls.Add($urlLabel)

    $textBox = New-Object Windows.Forms.TextBox
    $textBox.Location = New-Object Drawing.Point(20, 40)
    $textBox.Size = New-Object Drawing.Size(360, 20)
    $form.Controls.Add($textBox)

    $fileTypesLabel = New-Object Windows.Forms.Label
    $fileTypesLabel.Location = New-Object Drawing.Point(20, 80)
    $fileTypesLabel.Size = New-Object Drawing.Size(360, 20)
    $fileTypesLabel.Text = "Enter file types (comma-separated):"
    $form.Controls.Add($fileTypesLabel)

    $fileTypesTextBox = New-Object Windows.Forms.TextBox
    $fileTypesTextBox.Location = New-Object Drawing.Point(20, 100)
    $fileTypesTextBox.Size = New-Object Drawing.Size(360, 20)
    $fileTypesTextBox.Text = ".xlsx,.zip"
    $form.Controls.Add($fileTypesTextBox)

    $button = New-Object Windows.Forms.Button
    $button.Location = New-Object Drawing.Point(20, 140)
    $button.Size = New-Object Drawing.Size(360, 40)
    $button.Text = "Preview Files to Download"
    $form.Controls.Add($button)

    $statusLabel = New-Object Windows.Forms.Label
    $statusLabel.Location = New-Object Drawing.Point(20, 190)
    $statusLabel.Size = New-Object Drawing.Size(360, 20)
    $form.Controls.Add($statusLabel)

    $listButton = New-Object Windows.Forms.Button
    $listButton.Location = New-Object Drawing.Point(20, 230)
    $listButton.Size = New-Object Drawing.Size(360, 30)
    $listButton.Text = "View List of Files"
    $form.Controls.Add($listButton)

    $fileListTextBox = New-Object Windows.Forms.TextBox
    $fileListTextBox.Multiline = $true
    $fileListTextBox.ScrollBars = "Vertical"
    $fileListTextBox.Location = New-Object Drawing.Point(20, 260)
    $fileListTextBox.Size = New-Object Drawing.Size(360, 80)
    $form.Controls.Add($fileListTextBox)

    $button.Add_Click({
        $url = $textBox.Text
        $fileTypes = $fileTypesTextBox.Text -split ","
        $form.Controls.Remove($button)
        $form.Controls.Remove($listButton)
        $statusLabel.Text = "Finding files..."

        $response = Invoke-WebRequest -Uri $url
        $links = $response.Links | Where-Object { $_.href -match ($fileTypes -join "|") }
        $fileCount = $links.Count

        $totalSize = 0
        foreach ($link in $links) {
            $linkSizeResponse = Invoke-WebRequest -Uri ($url + $link.href) -Method Head
            $totalSize += [int]$linkSizeResponse.Headers["Content-Length"]
        }

        $statusLabel.Text = "Found $fileCount files with a total size of $($totalSize / 1MB) MB. Do you want to proceed?"

        $fileListTextBox.AppendText("Files to be downloaded:`r`n")
        foreach ($link in $links) {
            $fileName = [System.IO.Path]::GetFileName($link.href)
            $fileSizeKB = Get-ContentLength ($url + $link.href)
            $fileListTextBox.AppendText("$fileName - ${fileSizeKB} KB`r`n")
        } 

        $yesButton = New-Object Windows.Forms.Button
        $yesButton.Location = New-Object Drawing.Point(20, 360)
        $yesButton.Size = New-Object Drawing.Size(180, 30)
        $yesButton.Text = "Yes"
        $form.Controls.Add($yesButton)

        $noButton = New-Object Windows.Forms.Button
        $noButton.Location = New-Object Drawing.Point(200, 360)
        $noButton.Size = New-Object Drawing.Size(180, 30)
        $noButton.Text = "No"
        $form.Controls.Add($noButton)

        $yesButton.Add_Click({
            $form.Controls.Remove($yesButton)
            $form.Controls.Remove($noButton)
            $fileListTextBox.Visible = $false
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
            $fileListTextBox.Visible = $false
            $statusLabel.Text = "Canceled. Files not downloaded."
            $closeButton.Visible = $true
            $startOverButton.Visible = $true
        })
    })

    $closeButton.Add_Click({ $form.Close() })
    $startOverButton.Add_Click({ $form.Close(); Show-Form })

    # $listButton.Add_Click({
    #     $fileListTextBox.Visible = !$fileListTextBox.Visible
    # })

    $listButton.Click += {
        $fileListTextBox.Visible = !$fileListTextBox.Visible
    }

    $form.ShowDialog()
}

function Get-ContentLength($url) {
    $request = [System.Net.WebRequest]::Create($url)
    $request.Method = "HEAD"
    $response = $request.GetResponse()
    $fileSize = $response.Headers["Content-Length"]
    $response.Close()
    $fileSizeKB = [math]::Round($fileSize / 1024)
    return $fileSizeKB
}

Show-Form
