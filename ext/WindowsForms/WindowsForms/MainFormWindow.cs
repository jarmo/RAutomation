using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using UIA.Extensions;

namespace WindowsForms
{
    public partial class MainFormWindow : Form
    {
        public MainFormWindow()
        {
            InitializeComponent();
            automatableMonthCalendar1.AsValueControl<ValueMonthCalendar>();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void aboutButton_Click(object sender, EventArgs e)
        {
            var aboutBox = new AboutBox();
            aboutBox.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void checkBox_CheckedChanged(object sender, EventArgs e)
        {
            checkBoxLabel.Text = checkBox.Checked ? "checkBox is on" : "checkBox is off";
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            radioButtonLabel.Text = "Option 1 selected";
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            radioButtonLabel.Text = "Option 2 selected";
        }

        private void radioButtonReset_Click(object sender, EventArgs e)
        {
            radioButton1.Checked = false;
            radioButton2.Checked = false;
            radioButtonLabel.Text = "No option selected";
        }

        private void FruitsComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            fruitsLabel.Text = FruitsComboBox.Text;
        }

        private void nextFormButton_Click(object sender, EventArgs e)
        {
            var form = new DataEntryForm();
            form.Show();
        }

        private void buttonButton_Click(object sender, EventArgs e)
        {
            var buttonForm = new SimpleElementsForm();
            buttonForm.Show();
        }

        private void buttonDataGridView_Click(object sender, EventArgs e)
        {
            new DataGridView().Show();
        }

        private void FruitListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            var selectedFruits = (FruitListBox.SelectedItems.Cast<object>().Select(item => item.ToString()));
            fruitsLabel.Text = String.Join(",", selectedFruits);
        }
    }
}
