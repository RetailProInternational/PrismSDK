namespace WindowsFormsApp1
{
    partial class FrmMain
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
            this.tcDebugClient = new System.Windows.Forms.TabControl();
            this.PageServiceBrowser = new System.Windows.Forms.TabPage();
            this.PageRESTClient = new System.Windows.Forms.TabPage();
            this.ButtonGet = new System.Windows.Forms.Button();
            this.ButtonPost = new System.Windows.Forms.Button();
            this.ButtonPut = new System.Windows.Forms.Button();
            this.ButtonDelete = new System.Windows.Forms.Button();
            this.tcDebugClient.SuspendLayout();
            this.PageRESTClient.SuspendLayout();
            this.SuspendLayout();
            // 
            // tcDebugClient
            // 
            this.tcDebugClient.Controls.Add(this.PageServiceBrowser);
            this.tcDebugClient.Controls.Add(this.PageRESTClient);
            this.tcDebugClient.Location = new System.Drawing.Point(3, 3);
            this.tcDebugClient.Name = "tcDebugClient";
            this.tcDebugClient.SelectedIndex = 0;
            this.tcDebugClient.Size = new System.Drawing.Size(763, 473);
            this.tcDebugClient.TabIndex = 0;
            // 
            // PageServiceBrowser
            // 
            this.PageServiceBrowser.Location = new System.Drawing.Point(4, 22);
            this.PageServiceBrowser.Name = "PageServiceBrowser";
            this.PageServiceBrowser.Padding = new System.Windows.Forms.Padding(3);
            this.PageServiceBrowser.Size = new System.Drawing.Size(755, 447);
            this.PageServiceBrowser.TabIndex = 0;
            this.PageServiceBrowser.Text = "Service Browser";
            this.PageServiceBrowser.UseVisualStyleBackColor = true;
            // 
            // PageRESTClient
            // 
            this.PageRESTClient.Controls.Add(this.ButtonDelete);
            this.PageRESTClient.Controls.Add(this.ButtonPut);
            this.PageRESTClient.Controls.Add(this.ButtonPost);
            this.PageRESTClient.Controls.Add(this.ButtonGet);
            this.PageRESTClient.Location = new System.Drawing.Point(4, 22);
            this.PageRESTClient.Name = "PageRESTClient";
            this.PageRESTClient.Padding = new System.Windows.Forms.Padding(3);
            this.PageRESTClient.Size = new System.Drawing.Size(755, 447);
            this.PageRESTClient.TabIndex = 1;
            this.PageRESTClient.Text = "REST Client";
            this.PageRESTClient.UseVisualStyleBackColor = true;
            this.PageRESTClient.Click += new System.EventHandler(this.tpRESTClient_Click);
            // 
            // ButtonGet
            // 
            this.ButtonGet.Location = new System.Drawing.Point(6, 21);
            this.ButtonGet.Name = "ButtonGet";
            this.ButtonGet.Size = new System.Drawing.Size(75, 45);
            this.ButtonGet.TabIndex = 0;
            this.ButtonGet.Text = "Get";
            this.ButtonGet.UseVisualStyleBackColor = true;
            // 
            // ButtonPost
            // 
            this.ButtonPost.Location = new System.Drawing.Point(87, 21);
            this.ButtonPost.Name = "ButtonPost";
            this.ButtonPost.Size = new System.Drawing.Size(75, 45);
            this.ButtonPost.TabIndex = 1;
            this.ButtonPost.Text = "Post";
            this.ButtonPost.UseVisualStyleBackColor = true;
            // 
            // ButtonPut
            // 
            this.ButtonPut.Location = new System.Drawing.Point(168, 21);
            this.ButtonPut.Name = "ButtonPut";
            this.ButtonPut.Size = new System.Drawing.Size(75, 45);
            this.ButtonPut.TabIndex = 2;
            this.ButtonPut.Text = "Put";
            this.ButtonPut.UseVisualStyleBackColor = true;
            // 
            // ButtonDelete
            // 
            this.ButtonDelete.Location = new System.Drawing.Point(249, 21);
            this.ButtonDelete.Name = "ButtonDelete";
            this.ButtonDelete.Size = new System.Drawing.Size(75, 45);
            this.ButtonDelete.TabIndex = 3;
            this.ButtonDelete.Text = "Delete";
            this.ButtonDelete.UseVisualStyleBackColor = true;
            this.ButtonDelete.Click += new System.EventHandler(this.ButtonDelete_Click);
            // 
            // FrmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(765, 472);
            this.Controls.Add(this.tcDebugClient);
            this.Name = "FrmMain";
            this.Text = "Client Diagnostics";
            this.tcDebugClient.ResumeLayout(false);
            this.PageRESTClient.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl tcDebugClient;
        private System.Windows.Forms.TabPage PageServiceBrowser;
        private System.Windows.Forms.TabPage PageRESTClient;
        private System.Windows.Forms.Button ButtonGet;
        private System.Windows.Forms.Button ButtonDelete;
        private System.Windows.Forms.Button ButtonPut;
        private System.Windows.Forms.Button ButtonPost;
    }
}

