namespace ZeroMQ_CSharp2Delphi
{
    partial class FormMain
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
            this.rtbStatus = new System.Windows.Forms.RichTextBox();
            this.BtnStartServer = new System.Windows.Forms.Button();
            this.BtnSendMessage = new System.Windows.Forms.Button();
            this.BtnClearStatus = new System.Windows.Forms.Button();
            this.TbxSendMessage = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // rtbStatus
            // 
            this.rtbStatus.Location = new System.Drawing.Point(39, 80);
            this.rtbStatus.Name = "rtbStatus";
            this.rtbStatus.Size = new System.Drawing.Size(390, 159);
            this.rtbStatus.TabIndex = 0;
            this.rtbStatus.Text = "";
            // 
            // BtnStartServer
            // 
            this.BtnStartServer.Location = new System.Drawing.Point(349, 51);
            this.BtnStartServer.Name = "BtnStartServer";
            this.BtnStartServer.Size = new System.Drawing.Size(80, 23);
            this.BtnStartServer.TabIndex = 1;
            this.BtnStartServer.Text = "Start Server";
            this.BtnStartServer.UseVisualStyleBackColor = true;
            this.BtnStartServer.Click += new System.EventHandler(this.BtnStartServer_Click);
            // 
            // BtnSendMessage
            // 
            this.BtnSendMessage.Location = new System.Drawing.Point(39, 51);
            this.BtnSendMessage.Name = "BtnSendMessage";
            this.BtnSendMessage.Size = new System.Drawing.Size(113, 23);
            this.BtnSendMessage.TabIndex = 2;
            this.BtnSendMessage.Text = "Send Message";
            this.BtnSendMessage.UseVisualStyleBackColor = true;
            this.BtnSendMessage.Click += new System.EventHandler(this.BtnSendMessage_Click);
            // 
            // BtnClearStatus
            // 
            this.BtnClearStatus.Location = new System.Drawing.Point(40, 254);
            this.BtnClearStatus.Name = "BtnClearStatus";
            this.BtnClearStatus.Size = new System.Drawing.Size(75, 23);
            this.BtnClearStatus.TabIndex = 3;
            this.BtnClearStatus.Text = "Clear Status";
            this.BtnClearStatus.UseVisualStyleBackColor = true;
            // 
            // TbxSendMessage
            // 
            this.TbxSendMessage.Location = new System.Drawing.Point(40, 11);
            this.TbxSendMessage.Name = "TbxSendMessage";
            this.TbxSendMessage.Size = new System.Drawing.Size(389, 20);
            this.TbxSendMessage.TabIndex = 4;
            this.TbxSendMessage.Text = "Greetings";
            // 
            // FormMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(519, 369);
            this.Controls.Add(this.TbxSendMessage);
            this.Controls.Add(this.BtnClearStatus);
            this.Controls.Add(this.BtnSendMessage);
            this.Controls.Add(this.BtnStartServer);
            this.Controls.Add(this.rtbStatus);
            this.Name = "FormMain";
            this.Text = "ZeroMQ C# to Delphi";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RichTextBox rtbStatus;
        private System.Windows.Forms.Button BtnStartServer;
        private System.Windows.Forms.Button BtnSendMessage;
        private System.Windows.Forms.Button BtnClearStatus;
        private System.Windows.Forms.TextBox TbxSendMessage;
    }
}
