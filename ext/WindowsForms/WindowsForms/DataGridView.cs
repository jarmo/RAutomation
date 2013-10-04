using System;
using System.Windows.Forms;
using FizzWare.NBuilder;
using UIA.Extensions;

namespace WindowsForms
{
    public partial class DataGridView : Form
    {
        public DataGridView()
        {
            InitializeComponent();
	        dataGridView1.AsTable();
        }

        public class Person
        {
            // ReSharper disable UnusedMember.Local
            public String FirstName { get; set; }
            public String LastName { get; set; }
            public int Age { get; set; }
            public String City { get; set; }
            public String State { get; set; }
            // ReSharper restore UnusedMember.Local
        }

        private void DataGridView_Load(object sender, EventArgs e)
        {
            var dataSource = new BindingSource();
            foreach (var person in Builder<Person>.CreateListOfSize(50).Build())
            {
                dataSource.Add(person);
            }
            dataGridView1.AutoGenerateColumns = true;
            dataGridView1.DataSource = dataSource;
        }

        private void buttonClose_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
