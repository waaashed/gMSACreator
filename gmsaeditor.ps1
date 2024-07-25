# Charger les assemblies nécessaires
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Créer le formulaire
$form = New-Object System.Windows.Forms.Form
$form.Text = "Gestion des Principals pour gMSA"
$form.Width = 600
$form.Height = 500
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::White
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Créer un TableLayoutPanel pour organiser les contrôles
$tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel.RowCount = 8
$tableLayoutPanel.ColumnCount = 2
$tableLayoutPanel.AutoSize = $true
$tableLayoutPanel.CellBorderStyle = [System.Windows.Forms.TableLayoutPanelCellBorderStyle]::None
$tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$tableLayoutPanel.Padding = [System.Windows.Forms.Padding]::new(20)
$tableLayoutPanel.Margin = [System.Windows.Forms.Padding]::new(10)

# Définir les colonnes et les lignes avec espacement
$tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Absolute, 180)))  # Colonne pour les labels et les boutons
$tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))  # Colonne pour les zones de texte et les listbox

# Ajouter des lignes avec espacement
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))  # Row 0 pour label et textbox
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 10)))  # Espacement
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))  # Row 2 pour ListBox
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 10)))  # Espacement
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))  # Row 4 pour Charger et Supprimer Buttons
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 10)))  # Espacement
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))  # Row 6 pour Principal Label et TextBox
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))  # Row 7 pour Ajouter Button
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))  # Row 8 pour Status Label

$form.Controls.Add($tableLayoutPanel)

# Ajouter les contrôles au TableLayoutPanel
$label = New-Object System.Windows.Forms.Label
$label.Text = "Nom du compte de service :"
$label.AutoSize = $true
$label.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$tableLayoutPanel.Controls.Add($label, 0, 0)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Width = 250
$textBox.Height = 25
$textBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$tableLayoutPanel.Controls.Add($textBox, 1, 0)

$principalsListBox = New-Object System.Windows.Forms.ListBox
$principalsListBox.Width = 500
$principalsListBox.Height = 200
$principalsListBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$tableLayoutPanel.Controls.Add($principalsListBox, 0, 2)
$tableLayoutPanel.SetColumnSpan($principalsListBox, 2)

$loadButton = New-Object System.Windows.Forms.Button
$loadButton.Text = "Charger Principal(s)"
$loadButton.Width = 150
$loadButton.Height = 35
$loadButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$loadButton.BackColor = [System.Drawing.Color]::SteelBlue
$loadButton.ForeColor = [System.Drawing.Color]::White
$loadButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$tableLayoutPanel.Controls.Add($loadButton, 0, 4)

$removeButton = New-Object System.Windows.Forms.Button
$removeButton.Text = "Supprimer Principal"
$removeButton.Width = 150
$removeButton.Height = 35
$removeButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$removeButton.BackColor = [System.Drawing.Color]::SteelBlue
$removeButton.ForeColor = [System.Drawing.Color]::White
$removeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$tableLayoutPanel.Controls.Add($removeButton, 1, 4)

$principalLabel = New-Object System.Windows.Forms.Label
$principalLabel.Text = "Principal à ajouter :"
$principalLabel.AutoSize = $true
$principalLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$tableLayoutPanel.Controls.Add($principalLabel, 0, 6)

$principalTextBox = New-Object System.Windows.Forms.TextBox
$principalTextBox.Width = 250
$principalTextBox.Height = 25
$principalTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$tableLayoutPanel.Controls.Add($principalTextBox, 1, 6)

$addButton = New-Object System.Windows.Forms.Button
$addButton.Text = "Ajouter Principal"
$addButton.Width = 150
$addButton.Height = 35
$addButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$addButton.BackColor = [System.Drawing.Color]::SteelBlue
$addButton.ForeColor = [System.Drawing.Color]::White
$addButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$tableLayoutPanel.Controls.Add($addButton, 1, 7)

$errorMessageLabel = New-Object System.Windows.Forms.Label
$errorMessageLabel.AutoSize = $true
$errorMessageLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$tableLayoutPanel.Controls.Add($errorMessageLabel, 0, 8)
$tableLayoutPanel.SetColumnSpan($errorMessageLabel, 2)

# Gestion des clics du bouton Charger Principals
$loadButton.Add_Click({
    $serviceAccountName = $textBox.Text.Trim()

    if (-not $serviceAccountName) {
        # Afficher un message d'erreur dans le label
        $errorMessageLabel.Text = "Veuillez entrer le nom du compte de service."
        $errorMessageLabel.ForeColor = [System.Drawing.Color]::Red
        return
    }

    try {
        # Récupérer les principals autorisés à récupérer le mot de passe
        $principals = (Get-ADServiceAccount -Identity $serviceAccountName -Properties PrincipalsAllowedToRetrieveManagedPassword).PrincipalsAllowedToRetrieveManagedPassword
        $principalsListBox.Items.Clear()
        $principals | ForEach-Object { $principalsListBox.Items.Add($_) }
        $errorMessageLabel.Text = "Principals chargés avec succès."
        $errorMessageLabel.ForeColor = [System.Drawing.Color]::Green
    } catch {
        $errorMessageLabel.Text = "Une erreur s'est produite : $_"
        $errorMessageLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# Gestion des clics du bouton Ajouter Principal
$addButton.Add_Click({
    $serviceAccountName = $textBox.Text.Trim()
    $newPrincipal = $principalTextBox.Text.Trim()

    if (-not $serviceAccountName -or -not $newPrincipal) {
        $errorMessageLabel.Text = "Veuillez entrer le nom du compte de service et le principal à ajouter."
        $errorMessageLabel.ForeColor = [System.Drawing.Color]::Red
        return
    }

    try {
        # Récupérer les principals existants
        $principals = (Get-ADServiceAccount -Identity $serviceAccountName -Properties PrincipalsAllowedToRetrieveManagedPassword).PrincipalsAllowedToRetrieveManagedPassword
        $principalsArray = [array]$principals

        # Ajouter le nouveau principal
        $newPrincipalDistinguishedName = (Get-ADComputer -Identity $newPrincipal).DistinguishedName
        if ($principalsArray -notcontains $newPrincipalDistinguishedName) {
            $principalsArray += $newPrincipalDistinguishedName
            Set-ADServiceAccount -Identity $serviceAccountName -PrincipalsAllowedToRetrieveManagedPassword $principalsArray
            $principalsListBox.Items.Add($newPrincipalDistinguishedName)
            $errorMessageLabel.Text = "Principal ajouté avec succès."
            $errorMessageLabel.ForeColor = [System.Drawing.Color]::Green
        } else {
            $errorMessageLabel.Text = "Le principal est déjà dans la liste."
            $errorMessageLabel.ForeColor = [System.Drawing.Color]::Orange
        }
    } catch {
        $errorMessageLabel.Text = "Une erreur s'est produite : $_"
        $errorMessageLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# Gestion des clics du bouton Supprimer Principal
$removeButton.Add_Click({
    $serviceAccountName = $textBox.Text.Trim()
    $selectedPrincipal = $principalsListBox.SelectedItem

    if (-not $serviceAccountName -or -not $selectedPrincipal) {
        $errorMessageLabel.Text = "Veuillez sélectionner un principal à supprimer."
        $errorMessageLabel.ForeColor = [System.Drawing.Color]::Red
        return
    }

    try {
        # Récupérer les principals existants
        $principals = (Get-ADServiceAccount -Identity $serviceAccountName -Properties PrincipalsAllowedToRetrieveManagedPassword).PrincipalsAllowedToRetrieveManagedPassword
        $principalsArray = [array]$principals

        # Supprimer le principal sélectionné
        if ($principalsArray -contains $selectedPrincipal) {
            $principalsArray = $principalsArray | Where-Object { $_ -ne $selectedPrincipal }
            Set-ADServiceAccount -Identity $serviceAccountName -PrincipalsAllowedToRetrieveManagedPassword $principalsArray
            $principalsListBox.Items.Remove($selectedPrincipal)
            $errorMessageLabel.Text = "Principal supprimé avec succès."
            $errorMessageLabel.ForeColor = [System.Drawing.Color]::Green
        } else {
            $errorMessageLabel.Text = "Le principal sélectionné n'est pas dans la liste."
            $errorMessageLabel.ForeColor = [System.Drawing.Color]::Orange
        }
    } catch {
        $errorMessageLabel.Text = "Une erreur s'est produite : $_"
        $errorMessageLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# Afficher le formulaire
$form.ShowDialog()
