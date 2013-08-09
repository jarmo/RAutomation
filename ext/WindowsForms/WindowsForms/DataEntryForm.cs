using System;
using System.Windows.Forms;
using UIA.Extensions;

namespace WindowsForms
{
    public partial class DataEntryForm : Form
    {
        public DataEntryForm()
        {
            InitializeComponent();
            numericUpDown1.AsRangeValue();
        }

        private void closeDataEntryFormButton_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void addItemButton_Click(object sender, EventArgs e)
        {
            PersonForm personForm = new PersonForm(this);
            personForm.Show();
        }

        public void addPerson(String personName, String dateOfBirth)
        {
            ListViewItem newItem = new ListViewItem(personName);
            newItem.SubItems.Add(dateOfBirth);
            personListView.Items.Add(newItem);
        }

        private void deleteItemButton_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem item in personListView.SelectedItems)
            {
                personListView.Items.Remove(item);
            }
        }

        private void personListView_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

    }
}
