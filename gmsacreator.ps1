# Charger les assemblies nécessaires
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Créer le formulaire
$form = New-Object System.Windows.Forms.Form
$form.Text = "Créateur de gMSA"
$form.Width = 500
$form.Height = 400
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::White
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Créer un TableLayoutPanel pour organiser les contrôles
$tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel.RowCount = 7
$tableLayoutPanel.ColumnCount = 2
$tableLayoutPanel.AutoSize = $true
$tableLayoutPanel.CellBorderStyle = [System.Windows.Forms.TableLayoutPanelCellBorderStyle]::None
$tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$tableLayoutPanel.Padding = [System.Windows.Forms.Padding]::new(20)
$tableLayoutPanel.Margin = [System.Windows.Forms.Padding]::new(10)

# Définir les colonnes et les lignes avec espacement
$tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Absolute, 180)))
$tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))

# Ajouter des lignes avec espacement
for ($i = 0; $i -lt 6; $i++) {
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    if ($i -lt 5) {
        $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 10))) # Espacement entre les lignes
    }
}

$form.Controls.Add($tableLayoutPanel)

# Ajouter les labels et les zones de texte au TableLayoutPanel
$labels = @(
    "Nom du compte de service :", 
    "Description :", 
    "Nom de domaine :", 
    "Intervalle de changement du mot de passe (jours) :", 
    "Principal autorisé à récupérer le mot de passe :", 
    "Identité de la machine :"
)
$controls = @()

for ($i = 0; $i -lt $labels.Length; $i++) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $labels[$i]
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $label.Anchor = [System.Windows.Forms.AnchorStyles]::Left
    $tableLayoutPanel.Controls.Add($label, 0, $i * 2)

    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Width = 250
    $textbox.Height = 25
    $textbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $textbox.Anchor = [System.Windows.Forms.AnchorStyles]::Left
    $controls += $textbox
    $tableLayoutPanel.Controls.Add($textbox, 1, $i * 2)
}

# Ajouter un bouton de soumission
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Créer"
$submitButton.Width = 120
$submitButton.Height = 35
$submitButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$submitButton.BackColor = [System.Drawing.Color]::SteelBlue
$submitButton.ForeColor = [System.Drawing.Color]::White
$submitButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$submitButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom
$submitButton.Top = 300
$submitButton.Left = ($form.ClientSize.Width - $submitButton.Width) / 2
$submitButton.Add_Click({
    # Récupérer les valeurs des contrôles
    $ServiceAccountName = $controls[0].Text
    $ServiceAccountDescription = $controls[1].Text
    $DomainName = $controls[2].Text
    $DNSHostName = "$ServiceAccountName.$DomainName"
    $ManagedPasswordIntervalInDays = [int]$controls[3].Text
    $PrincipalAllowedToRetrievePassword = "$($controls[4].Text)$"
    $MachineIdentity = $controls[5].Text

    # Validation des champs
    if (-not $ServiceAccountName -or -not $DomainName -or -not $MachineIdentity) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez remplir tous les champs obligatoires.", "Erreur de saisie", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Vérifier la longueur du nom du compte de service
    if ($ServiceAccountName.Length -gt 15) {
        [System.Windows.Forms.MessageBox]::Show("Le nom du compte de service ne doit pas dépasser 15 caractères.", "Erreur de saisie", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    try {
        # Créer le compte de service gMSA
        Write-Host "Création du compte de service gMSA..."
        New-ADServiceAccount -Name $ServiceAccountName `
                              -Description $ServiceAccountDescription `
                              -DNSHostName $DNSHostName `
                              -ManagedPasswordIntervalInDays $ManagedPasswordIntervalInDays `
                              -PrincipalsAllowedToRetrieveManagedPassword $PrincipalAllowedToRetrievePassword `
                              -Enabled $True

        # Associer le compte de service à la machine
        Write-Host "Association du compte de service avec la machine..."
        Add-ADComputerServiceAccount -Identity $MachineIdentity `
                                      -ServiceAccount $ServiceAccountName

        # Message de succès
        [System.Windows.Forms.MessageBox]::Show("Compte de service gMSA créé et associé avec succès.", "Succès", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        # Message d'erreur
        [System.Windows.Forms.MessageBox]::Show("Une erreur s'est produite : $_", "Erreur", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    
    # Fermer le formulaire
    $form.Close()
})

$form.Controls.Add($submitButton)

# Ajouter un label de crédit sous le bouton
$creditLabel = New-Object System.Windows.Forms.Label
$creditLabel.Text = "GRIGNON Benjamin"
$creditLabel.Font = New-Object System.Drawing.Font("Segoe UI", 7, [System.Drawing.FontStyle]::Italic)
$creditLabel.AutoSize = $true
$creditLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$creditLabel.Left = ($form.ClientSize.Width - $creditLabel.Width) / 2
$creditLabel.Top = $submitButton.Bottom + 5 # Positionner en dessous du bouton
$form.Controls.Add($creditLabel)

# Afficher le formulaire
$form.ShowDialog()
