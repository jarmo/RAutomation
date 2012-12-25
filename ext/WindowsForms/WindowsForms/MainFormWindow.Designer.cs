namespace WindowsForms
{
    partial class MainFormWindow
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.TreeNode treeNode1 = new System.Windows.Forms.TreeNode("Child 1");
            System.Windows.Forms.TreeNode treeNode2 = new System.Windows.Forms.TreeNode("Grandchild 1");
            System.Windows.Forms.TreeNode treeNode3 = new System.Windows.Forms.TreeNode("Child 2", new System.Windows.Forms.TreeNode[] {
            treeNode2});
            System.Windows.Forms.TreeNode treeNode4 = new System.Windows.Forms.TreeNode("Parent One", new System.Windows.Forms.TreeNode[] {
            treeNode1,
            treeNode3});
            System.Windows.Forms.TreeNode treeNode5 = new System.Windows.Forms.TreeNode("Parent Two");
            this.label1 = new System.Windows.Forms.Label();
            this.aboutButton = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.textField = new System.Windows.Forms.TextBox();
            this.checkBox = new System.Windows.Forms.CheckBox();
            this.checkBoxLabel = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.radioButtonDisabled = new System.Windows.Forms.RadioButton();
            this.radioButtonReset = new System.Windows.Forms.Button();
            this.radioButtonLabel = new System.Windows.Forms.Label();
            this.radioButton2 = new System.Windows.Forms.RadioButton();
            this.radioButton1 = new System.Windows.Forms.RadioButton();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.comboBoxDisabled = new System.Windows.Forms.ComboBox();
            this.fruitsLabel = new System.Windows.Forms.Label();
            this.FruitsComboBox = new System.Windows.Forms.ComboBox();
            this.nextFormButton = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.buttonButton = new System.Windows.Forms.Button();
            this.enabledButton = new System.Windows.Forms.Button();
            this.disabledButton = new System.Windows.Forms.Button();
            this.checkBoxDisabled = new System.Windows.Forms.CheckBox();
            this.textBoxDisabled = new System.Windows.Forms.TextBox();
            this.FruitListBox = new System.Windows.Forms.ListBox();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.faileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aboutToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.roundaboutWayToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aboutToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.treeView = new System.Windows.Forms.TreeView();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(139, 65);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(102, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "This is a sample text";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // aboutButton
            // 
            this.aboutButton.Location = new System.Drawing.Point(12, 36);
            this.aboutButton.Name = "aboutButton";
            this.aboutButton.Size = new System.Drawing.Size(95, 23);
            this.aboutButton.TabIndex = 1;
            this.aboutButton.Text = "&About";
            this.aboutButton.UseVisualStyleBackColor = true;
            this.aboutButton.Click += new System.EventHandler(this.aboutButton_Click);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(12, 123);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(95, 23);
            this.button1.TabIndex = 4;
            this.button1.Text = "Close";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // textField
            // 
            this.textField.Location = new System.Drawing.Point(142, 96);
            this.textField.Name = "textField";
            this.textField.Size = new System.Drawing.Size(184, 20);
            this.textField.TabIndex = 5;
            // 
            // checkBox
            // 
            this.checkBox.AutoSize = true;
            this.checkBox.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.checkBox.Location = new System.Drawing.Point(142, 132);
            this.checkBox.Name = "checkBox";
            this.checkBox.Size = new System.Drawing.Size(80, 18);
            this.checkBox.TabIndex = 6;
            this.checkBox.Text = "checkBox";
            this.checkBox.UseVisualStyleBackColor = true;
            this.checkBox.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // checkBoxLabel
            // 
            this.checkBoxLabel.AutoSize = true;
            this.checkBoxLabel.Location = new System.Drawing.Point(246, 133);
            this.checkBoxLabel.Name = "checkBoxLabel";
            this.checkBoxLabel.Size = new System.Drawing.Size(80, 13);
            this.checkBoxLabel.TabIndex = 5;
            this.checkBoxLabel.Text = "checkBox is off";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.radioButtonDisabled);
            this.groupBox1.Controls.Add(this.radioButtonReset);
            this.groupBox1.Controls.Add(this.radioButtonLabel);
            this.groupBox1.Controls.Add(this.radioButton2);
            this.groupBox1.Controls.Add(this.radioButton1);
            this.groupBox1.Location = new System.Drawing.Point(142, 163);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(325, 89);
            this.groupBox1.TabIndex = 6;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Groupd of radio buttons";
            // 
            // radioButtonDisabled
            // 
            this.radioButtonDisabled.AutoSize = true;
            this.radioButtonDisabled.Enabled = false;
            this.radioButtonDisabled.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.radioButtonDisabled.Location = new System.Drawing.Point(188, 28);
            this.radioButtonDisabled.Name = "radioButtonDisabled";
            this.radioButtonDisabled.Size = new System.Drawing.Size(106, 18);
            this.radioButtonDisabled.TabIndex = 10;
            this.radioButtonDisabled.TabStop = true;
            this.radioButtonDisabled.Text = "Option Disabled";
            this.radioButtonDisabled.UseVisualStyleBackColor = true;
            // 
            // radioButtonReset
            // 
            this.radioButtonReset.Location = new System.Drawing.Point(143, 56);
            this.radioButtonReset.Name = "radioButtonReset";
            this.radioButtonReset.Size = new System.Drawing.Size(75, 23);
            this.radioButtonReset.TabIndex = 9;
            this.radioButtonReset.Text = "Reset";
            this.radioButtonReset.UseVisualStyleBackColor = true;
            this.radioButtonReset.Click += new System.EventHandler(this.radioButtonReset_Click);
            // 
            // radioButtonLabel
            // 
            this.radioButtonLabel.AutoSize = true;
            this.radioButtonLabel.Location = new System.Drawing.Point(6, 61);
            this.radioButtonLabel.Name = "radioButtonLabel";
            this.radioButtonLabel.Size = new System.Drawing.Size(96, 13);
            this.radioButtonLabel.TabIndex = 2;
            this.radioButtonLabel.Text = "No option selected";
            // 
            // radioButton2
            // 
            this.radioButton2.AutoSize = true;
            this.radioButton2.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.radioButton2.Location = new System.Drawing.Point(107, 28);
            this.radioButton2.Name = "radioButton2";
            this.radioButton2.Size = new System.Drawing.Size(71, 18);
            this.radioButton2.TabIndex = 8;
            this.radioButton2.TabStop = true;
            this.radioButton2.Text = "Option 2";
            this.radioButton2.UseVisualStyleBackColor = true;
            this.radioButton2.CheckedChanged += new System.EventHandler(this.radioButton2_CheckedChanged);
            // 
            // radioButton1
            // 
            this.radioButton1.AutoSize = true;
            this.radioButton1.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.radioButton1.Location = new System.Drawing.Point(9, 28);
            this.radioButton1.Name = "radioButton1";
            this.radioButton1.Size = new System.Drawing.Size(71, 18);
            this.radioButton1.TabIndex = 7;
            this.radioButton1.TabStop = true;
            this.radioButton1.Text = "Option 1";
            this.radioButton1.UseVisualStyleBackColor = true;
            this.radioButton1.CheckedChanged += new System.EventHandler(this.radioButton1_CheckedChanged);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.comboBoxDisabled);
            this.groupBox2.Controls.Add(this.fruitsLabel);
            this.groupBox2.Controls.Add(this.FruitsComboBox);
            this.groupBox2.Location = new System.Drawing.Point(142, 258);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(325, 63);
            this.groupBox2.TabIndex = 7;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Drop down list";
            // 
            // comboBoxDisabled
            // 
            this.comboBoxDisabled.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxDisabled.Enabled = false;
            this.comboBoxDisabled.FormattingEnabled = true;
            this.comboBoxDisabled.Items.AddRange(new object[] {
            "Apple",
            "Caimito",
            "Coconut",
            "Orange",
            "Passion Fruit"});
            this.comboBoxDisabled.Location = new System.Drawing.Point(235, 27);
            this.comboBoxDisabled.Name = "comboBoxDisabled";
            this.comboBoxDisabled.Size = new System.Drawing.Size(84, 21);
            this.comboBoxDisabled.TabIndex = 11;
            // 
            // fruitsLabel
            // 
            this.fruitsLabel.AutoSize = true;
            this.fruitsLabel.Location = new System.Drawing.Point(133, 30);
            this.fruitsLabel.Name = "fruitsLabel";
            this.fruitsLabel.Size = new System.Drawing.Size(35, 13);
            this.fruitsLabel.TabIndex = 1;
            this.fruitsLabel.Text = "label2";
            // 
            // FruitsComboBox
            // 
            this.FruitsComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.FruitsComboBox.FormattingEnabled = true;
            this.FruitsComboBox.Items.AddRange(new object[] {
            "Apple",
            "Caimito",
            "Coconut",
            "Orange",
            "Passion Fruit"});
            this.FruitsComboBox.Location = new System.Drawing.Point(6, 27);
            this.FruitsComboBox.Name = "FruitsComboBox";
            this.FruitsComboBox.Size = new System.Drawing.Size(121, 21);
            this.FruitsComboBox.TabIndex = 10;
            this.FruitsComboBox.SelectedIndexChanged += new System.EventHandler(this.FruitsComboBox_SelectedIndexChanged);
            // 
            // nextFormButton
            // 
            this.nextFormButton.Location = new System.Drawing.Point(12, 65);
            this.nextFormButton.Name = "nextFormButton";
            this.nextFormButton.Size = new System.Drawing.Size(95, 23);
            this.nextFormButton.TabIndex = 2;
            this.nextFormButton.Text = "Data Entry Form";
            this.nextFormButton.UseVisualStyleBackColor = true;
            this.nextFormButton.Click += new System.EventHandler(this.nextFormButton_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(139, 41);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(108, 13);
            this.label2.TabIndex = 9;
            this.label2.Text = "Assorted UI Elements";
            // 
            // buttonButton
            // 
            this.buttonButton.Location = new System.Drawing.Point(12, 94);
            this.buttonButton.Name = "buttonButton";
            this.buttonButton.Size = new System.Drawing.Size(95, 23);
            this.buttonButton.TabIndex = 3;
            this.buttonButton.Text = "Simple Elements";
            this.buttonButton.UseVisualStyleBackColor = true;
            this.buttonButton.Click += new System.EventHandler(this.buttonButton_Click);
            // 
            // enabledButton
            // 
            this.enabledButton.Location = new System.Drawing.Point(574, 54);
            this.enabledButton.Name = "enabledButton";
            this.enabledButton.Size = new System.Drawing.Size(75, 23);
            this.enabledButton.TabIndex = 10;
            this.enabledButton.Text = "Enabled";
            this.enabledButton.UseVisualStyleBackColor = true;
            // 
            // disabledButton
            // 
            this.disabledButton.Enabled = false;
            this.disabledButton.Location = new System.Drawing.Point(574, 96);
            this.disabledButton.Name = "disabledButton";
            this.disabledButton.Size = new System.Drawing.Size(75, 23);
            this.disabledButton.TabIndex = 11;
            this.disabledButton.Text = "Disabled";
            this.disabledButton.UseVisualStyleBackColor = true;
            // 
            // checkBoxDisabled
            // 
            this.checkBoxDisabled.AutoSize = true;
            this.checkBoxDisabled.Enabled = false;
            this.checkBoxDisabled.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.checkBoxDisabled.Location = new System.Drawing.Point(353, 129);
            this.checkBoxDisabled.Name = "checkBoxDisabled";
            this.checkBoxDisabled.Size = new System.Drawing.Size(121, 18);
            this.checkBoxDisabled.TabIndex = 12;
            this.checkBoxDisabled.Text = "checkBoxDisabled";
            this.checkBoxDisabled.UseVisualStyleBackColor = true;
            // 
            // textBoxDisabled
            // 
            this.textBoxDisabled.Enabled = false;
            this.textBoxDisabled.Location = new System.Drawing.Point(332, 96);
            this.textBoxDisabled.Name = "textBoxDisabled";
            this.textBoxDisabled.Size = new System.Drawing.Size(184, 20);
            this.textBoxDisabled.TabIndex = 13;
            // 
            // FruitListBox
            // 
            this.FruitListBox.FormattingEnabled = true;
            this.FruitListBox.Items.AddRange(new object[] {
            "Apple",
            "Orange",
            "Mango"});
            this.FruitListBox.Location = new System.Drawing.Point(490, 163);
            this.FruitListBox.Name = "FruitListBox";
            this.FruitListBox.Size = new System.Drawing.Size(159, 95);
            this.FruitListBox.TabIndex = 14;
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.faileToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(724, 24);
            this.menuStrip1.TabIndex = 15;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // faileToolStripMenuItem
            // 
            this.faileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.aboutToolStripMenuItem,
            this.roundaboutWayToolStripMenuItem});
            this.faileToolStripMenuItem.Name = "faileToolStripMenuItem";
            this.faileToolStripMenuItem.Size = new System.Drawing.Size(37, 20);
            this.faileToolStripMenuItem.Text = "&File";
            // 
            // aboutToolStripMenuItem
            // 
            this.aboutToolStripMenuItem.Name = "aboutToolStripMenuItem";
            this.aboutToolStripMenuItem.Size = new System.Drawing.Size(166, 22);
            this.aboutToolStripMenuItem.Text = "&About";
            this.aboutToolStripMenuItem.Click += new System.EventHandler(this.aboutButton_Click);
            // 
            // roundaboutWayToolStripMenuItem
            // 
            this.roundaboutWayToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toToolStripMenuItem});
            this.roundaboutWayToolStripMenuItem.Name = "roundaboutWayToolStripMenuItem";
            this.roundaboutWayToolStripMenuItem.Size = new System.Drawing.Size(166, 22);
            this.roundaboutWayToolStripMenuItem.Text = "Roundabout Way";
            // 
            // toToolStripMenuItem
            // 
            this.toToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.aboutToolStripMenuItem1});
            this.toToolStripMenuItem.Name = "toToolStripMenuItem";
            this.toToolStripMenuItem.Size = new System.Drawing.Size(88, 22);
            this.toToolStripMenuItem.Text = "To";
            // 
            // aboutToolStripMenuItem1
            // 
            this.aboutToolStripMenuItem1.Name = "aboutToolStripMenuItem1";
            this.aboutToolStripMenuItem1.Size = new System.Drawing.Size(107, 22);
            this.aboutToolStripMenuItem1.Text = "&About";
            this.aboutToolStripMenuItem1.Click += new System.EventHandler(this.aboutButton_Click);
            // 
            // treeView
            // 
            this.treeView.Location = new System.Drawing.Point(490, 285);
            this.treeView.Name = "treeView";
            treeNode1.Name = "Child 1";
            treeNode1.Text = "Child 1";
            treeNode2.Name = "Grandchild 1";
            treeNode2.Text = "Grandchild 1";
            treeNode3.Name = "Child 2";
            treeNode3.Text = "Child 2";
            treeNode4.Name = "Parent One";
            treeNode4.Text = "Parent One";
            treeNode5.Name = "Parent Two";
            treeNode5.Text = "Parent Two";
            this.treeView.Nodes.AddRange(new System.Windows.Forms.TreeNode[] {
            treeNode4,
            treeNode5});
            this.treeView.Size = new System.Drawing.Size(159, 177);
            this.treeView.TabIndex = 16;
            // 
            // MainFormWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(724, 474);
            this.Controls.Add(this.treeView);
            this.Controls.Add(this.FruitListBox);
            this.Controls.Add(this.textBoxDisabled);
            this.Controls.Add(this.checkBoxDisabled);
            this.Controls.Add(this.disabledButton);
            this.Controls.Add(this.enabledButton);
            this.Controls.Add(this.buttonButton);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.nextFormButton);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.checkBoxLabel);
            this.Controls.Add(this.checkBox);
            this.Controls.Add(this.textField);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.aboutButton);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "MainFormWindow";
            this.Text = "MainFormWindow";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button aboutButton;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox textField;
        private System.Windows.Forms.CheckBox checkBox;
        private System.Windows.Forms.Label checkBoxLabel;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label radioButtonLabel;
        private System.Windows.Forms.RadioButton radioButton2;
        private System.Windows.Forms.RadioButton radioButton1;
        private System.Windows.Forms.Button radioButtonReset;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.ComboBox FruitsComboBox;
        private System.Windows.Forms.Label fruitsLabel;
        private System.Windows.Forms.Button nextFormButton;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button buttonButton;
        private System.Windows.Forms.Button enabledButton;
        private System.Windows.Forms.Button disabledButton;
        private System.Windows.Forms.CheckBox checkBoxDisabled;
        private System.Windows.Forms.RadioButton radioButtonDisabled;
        private System.Windows.Forms.TextBox textBoxDisabled;
        private System.Windows.Forms.ComboBox comboBoxDisabled;
        private System.Windows.Forms.ListBox FruitListBox;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem faileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem roundaboutWayToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem toToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem1;
        private System.Windows.Forms.TreeView treeView;
    }
}

