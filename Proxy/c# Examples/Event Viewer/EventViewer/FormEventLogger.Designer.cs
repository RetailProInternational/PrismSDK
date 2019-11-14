namespace EventLoggerNS
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
            this.BtnStart = new System.Windows.Forms.Button();
            this.BtnStop = new System.Windows.Forms.Button();
            this.BtnToken = new System.Windows.Forms.Button();
            this.BtnGlobalConfigData = new System.Windows.Forms.Button();
            this.BtnWSConfigData = new System.Windows.Forms.Button();
            this.RtbParams = new System.Windows.Forms.RichTextBox();
            this.LabelResourceData = new System.Windows.Forms.Label();
            this.LabelVerbData = new System.Windows.Forms.Label();
            this.LabelDirectionData = new System.Windows.Forms.Label();
            this.LabelResource = new System.Windows.Forms.Label();
            this.LabelVerb = new System.Windows.Forms.Label();
            this.LabelDirection = new System.Windows.Forms.Label();
            this.PanelTop = new System.Windows.Forms.Panel();
            this.PanelDetails = new System.Windows.Forms.Panel();
            this.ContentData = new System.Windows.Forms.Label();
            this.URIData = new System.Windows.Forms.Label();
            this.Content = new System.Windows.Forms.Label();
            this.URI = new System.Windows.Forms.Label();
            this.LabelPayload = new System.Windows.Forms.Label();
            this.LabelQueryString = new System.Windows.Forms.Label();
            this.RtbPayload = new System.Windows.Forms.RichTextBox();
            this.eventViewerGrid = new System.Windows.Forms.DataGridView();
            this.ApiDirection = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Verb = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Resource = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.PanelTop.SuspendLayout();
            this.PanelDetails.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.eventViewerGrid)).BeginInit();
            this.SuspendLayout();
            // 
            // BtnStart
            // 
            this.BtnStart.Location = new System.Drawing.Point(3, 0);
            this.BtnStart.Name = "BtnStart";
            this.BtnStart.Size = new System.Drawing.Size(90, 40);
            this.BtnStart.TabIndex = 0;
            this.BtnStart.Text = "Start";
            this.BtnStart.UseVisualStyleBackColor = true;
            this.BtnStart.Click += new System.EventHandler(this.BtnStart_Click);
            // 
            // BtnStop
            // 
            this.BtnStop.Location = new System.Drawing.Point(99, 0);
            this.BtnStop.Name = "BtnStop";
            this.BtnStop.Size = new System.Drawing.Size(90, 40);
            this.BtnStop.TabIndex = 1;
            this.BtnStop.Text = "Stop";
            this.BtnStop.UseVisualStyleBackColor = true;
            this.BtnStop.Click += new System.EventHandler(this.BtnStop_Click);
            // 
            // BtnToken
            // 
            this.BtnToken.Location = new System.Drawing.Point(463, 3);
            this.BtnToken.Name = "BtnToken";
            this.BtnToken.Size = new System.Drawing.Size(90, 40);
            this.BtnToken.TabIndex = 2;
            this.BtnToken.Text = "Token";
            this.BtnToken.UseVisualStyleBackColor = true;
            this.BtnToken.Click += new System.EventHandler(this.BtnToken_Click);
            // 
            // BtnGlobalConfigData
            // 
            this.BtnGlobalConfigData.Location = new System.Drawing.Point(559, 3);
            this.BtnGlobalConfigData.Name = "BtnGlobalConfigData";
            this.BtnGlobalConfigData.Size = new System.Drawing.Size(90, 40);
            this.BtnGlobalConfigData.TabIndex = 3;
            this.BtnGlobalConfigData.Text = "Global Config Data";
            this.BtnGlobalConfigData.UseVisualStyleBackColor = true;
            // 
            // BtnWSConfigData
            // 
            this.BtnWSConfigData.Location = new System.Drawing.Point(655, 3);
            this.BtnWSConfigData.Name = "BtnWSConfigData";
            this.BtnWSConfigData.Size = new System.Drawing.Size(90, 40);
            this.BtnWSConfigData.TabIndex = 4;
            this.BtnWSConfigData.Text = "WS Config Data";
            this.BtnWSConfigData.UseVisualStyleBackColor = true;
            // 
            // RtbParams
            // 
            this.RtbParams.Location = new System.Drawing.Point(88, 98);
            this.RtbParams.Name = "RtbParams";
            this.RtbParams.Size = new System.Drawing.Size(621, 39);
            this.RtbParams.TabIndex = 15;
            this.RtbParams.Text = "";
            // 
            // LabelResourceData
            // 
            this.LabelResourceData.AutoSize = true;
            this.LabelResourceData.Location = new System.Drawing.Point(85, 78);
            this.LabelResourceData.Name = "LabelResourceData";
            this.LabelResourceData.Size = new System.Drawing.Size(48, 13);
            this.LabelResourceData.TabIndex = 21;
            this.LabelResourceData.Text = "resource";
            // 
            // LabelVerbData
            // 
            this.LabelVerbData.AutoSize = true;
            this.LabelVerbData.Location = new System.Drawing.Point(85, 62);
            this.LabelVerbData.Name = "LabelVerbData";
            this.LabelVerbData.Size = new System.Drawing.Size(28, 13);
            this.LabelVerbData.TabIndex = 20;
            this.LabelVerbData.Text = "verb";
            // 
            // LabelDirectionData
            // 
            this.LabelDirectionData.AutoSize = true;
            this.LabelDirectionData.Location = new System.Drawing.Point(85, 10);
            this.LabelDirectionData.Name = "LabelDirectionData";
            this.LabelDirectionData.Size = new System.Drawing.Size(47, 13);
            this.LabelDirectionData.TabIndex = 19;
            this.LabelDirectionData.Text = "direction";
            // 
            // LabelResource
            // 
            this.LabelResource.AutoSize = true;
            this.LabelResource.Location = new System.Drawing.Point(18, 78);
            this.LabelResource.Name = "LabelResource";
            this.LabelResource.Size = new System.Drawing.Size(56, 13);
            this.LabelResource.TabIndex = 18;
            this.LabelResource.Text = "Resource:";
            // 
            // LabelVerb
            // 
            this.LabelVerb.AutoSize = true;
            this.LabelVerb.Location = new System.Drawing.Point(42, 61);
            this.LabelVerb.Name = "LabelVerb";
            this.LabelVerb.Size = new System.Drawing.Size(32, 13);
            this.LabelVerb.TabIndex = 17;
            this.LabelVerb.Text = "Verb:";
            // 
            // LabelDirection
            // 
            this.LabelDirection.AutoSize = true;
            this.LabelDirection.Location = new System.Drawing.Point(22, 10);
            this.LabelDirection.Name = "LabelDirection";
            this.LabelDirection.Size = new System.Drawing.Size(52, 13);
            this.LabelDirection.TabIndex = 16;
            this.LabelDirection.Text = "Direction:";
            // 
            // PanelTop
            // 
            this.PanelTop.Controls.Add(this.BtnStart);
            this.PanelTop.Controls.Add(this.BtnWSConfigData);
            this.PanelTop.Controls.Add(this.BtnStop);
            this.PanelTop.Controls.Add(this.BtnToken);
            this.PanelTop.Controls.Add(this.BtnGlobalConfigData);
            this.PanelTop.Location = new System.Drawing.Point(5, 12);
            this.PanelTop.Name = "PanelTop";
            this.PanelTop.Size = new System.Drawing.Size(763, 50);
            this.PanelTop.TabIndex = 22;
            // 
            // PanelDetails
            // 
            this.PanelDetails.Controls.Add(this.ContentData);
            this.PanelDetails.Controls.Add(this.URIData);
            this.PanelDetails.Controls.Add(this.Content);
            this.PanelDetails.Controls.Add(this.URI);
            this.PanelDetails.Controls.Add(this.LabelPayload);
            this.PanelDetails.Controls.Add(this.LabelQueryString);
            this.PanelDetails.Controls.Add(this.RtbPayload);
            this.PanelDetails.Controls.Add(this.LabelDirection);
            this.PanelDetails.Controls.Add(this.LabelVerb);
            this.PanelDetails.Controls.Add(this.RtbParams);
            this.PanelDetails.Controls.Add(this.LabelResourceData);
            this.PanelDetails.Controls.Add(this.LabelResource);
            this.PanelDetails.Controls.Add(this.LabelVerbData);
            this.PanelDetails.Controls.Add(this.LabelDirectionData);
            this.PanelDetails.Location = new System.Drawing.Point(5, 373);
            this.PanelDetails.Name = "PanelDetails";
            this.PanelDetails.Size = new System.Drawing.Size(763, 222);
            this.PanelDetails.TabIndex = 23;
            // 
            // ContentData
            // 
            this.ContentData.AutoSize = true;
            this.ContentData.Location = new System.Drawing.Point(85, 44);
            this.ContentData.Name = "ContentData";
            this.ContentData.Size = new System.Drawing.Size(43, 13);
            this.ContentData.TabIndex = 28;
            this.ContentData.Text = "content";
            // 
            // URIData
            // 
            this.URIData.AutoSize = true;
            this.URIData.Location = new System.Drawing.Point(85, 28);
            this.URIData.Name = "URIData";
            this.URIData.Size = new System.Drawing.Size(18, 13);
            this.URIData.TabIndex = 27;
            this.URIData.Text = "uri";
            // 
            // Content
            // 
            this.Content.AutoSize = true;
            this.Content.Location = new System.Drawing.Point(27, 44);
            this.Content.Name = "Content";
            this.Content.Size = new System.Drawing.Size(47, 13);
            this.Content.TabIndex = 26;
            this.Content.Text = "Content:";
            // 
            // URI
            // 
            this.URI.AutoSize = true;
            this.URI.Location = new System.Drawing.Point(45, 28);
            this.URI.Name = "URI";
            this.URI.Size = new System.Drawing.Size(29, 13);
            this.URI.TabIndex = 25;
            this.URI.Text = "URI:";
            // 
            // LabelPayload
            // 
            this.LabelPayload.AutoSize = true;
            this.LabelPayload.Location = new System.Drawing.Point(26, 143);
            this.LabelPayload.Name = "LabelPayload";
            this.LabelPayload.Size = new System.Drawing.Size(48, 13);
            this.LabelPayload.TabIndex = 24;
            this.LabelPayload.Text = "Payload:";
            // 
            // LabelQueryString
            // 
            this.LabelQueryString.AutoSize = true;
            this.LabelQueryString.Location = new System.Drawing.Point(6, 99);
            this.LabelQueryString.Name = "LabelQueryString";
            this.LabelQueryString.Size = new System.Drawing.Size(68, 13);
            this.LabelQueryString.TabIndex = 23;
            this.LabelQueryString.Text = "Query String:";
            // 
            // RtbPayload
            // 
            this.RtbPayload.Location = new System.Drawing.Point(88, 143);
            this.RtbPayload.Name = "RtbPayload";
            this.RtbPayload.Size = new System.Drawing.Size(621, 72);
            this.RtbPayload.TabIndex = 22;
            this.RtbPayload.Text = "";
            // 
            // eventViewerGrid
            // 
            this.eventViewerGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.eventViewerGrid.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.ApiDirection,
            this.Verb,
            this.Resource});
            this.eventViewerGrid.Location = new System.Drawing.Point(5, 61);
            this.eventViewerGrid.MultiSelect = false;
            this.eventViewerGrid.Name = "eventViewerGrid";
            this.eventViewerGrid.Size = new System.Drawing.Size(763, 298);
            this.eventViewerGrid.TabIndex = 24;
            this.eventViewerGrid.RowEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.EventViewerGrid_RowEnter);
            // 
            // ApiDirection
            // 
            this.ApiDirection.DataPropertyName = "ApiDirection";
            this.ApiDirection.HeaderText = "ApiDirection";
            this.ApiDirection.Name = "ApiDirection";
            this.ApiDirection.Width = 80;
            // 
            // Verb
            // 
            this.Verb.DataPropertyName = "Verb";
            this.Verb.HeaderText = "Verb";
            this.Verb.Name = "Verb";
            this.Verb.Width = 300;
            // 
            // Resource
            // 
            this.Resource.DataPropertyName = "Resource";
            this.Resource.HeaderText = "Resource";
            this.Resource.Name = "Resource";
            this.Resource.Width = 340;
            // 
            // FrmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(765, 596);
            this.Controls.Add(this.eventViewerGrid);
            this.Controls.Add(this.PanelDetails);
            this.Controls.Add(this.PanelTop);
            this.Name = "FrmMain";
            this.Text = "Event Logger";
            this.PanelTop.ResumeLayout(false);
            this.PanelDetails.ResumeLayout(false);
            this.PanelDetails.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.eventViewerGrid)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.Button BtnWSConfigData;
        private System.Windows.Forms.Button BtnGlobalConfigData;
        private System.Windows.Forms.Button BtnToken;
        private System.Windows.Forms.Button BtnStop;
        private System.Windows.Forms.Button BtnStart;
        private System.Windows.Forms.RichTextBox RtbParams;
        private System.Windows.Forms.Label LabelResourceData;
        private System.Windows.Forms.Label LabelVerbData;
        private System.Windows.Forms.Label LabelDirectionData;
        private System.Windows.Forms.Label LabelResource;
        private System.Windows.Forms.Label LabelVerb;
        private System.Windows.Forms.Label LabelDirection;
        private System.Windows.Forms.Panel PanelTop;
        private System.Windows.Forms.Panel PanelDetails;
        private System.Windows.Forms.Label LabelPayload;
        private System.Windows.Forms.Label LabelQueryString;
        private System.Windows.Forms.RichTextBox RtbPayload;
        private System.Windows.Forms.DataGridView eventViewerGrid;
        private System.Windows.Forms.Label URIData;
        private System.Windows.Forms.Label Content;
        private System.Windows.Forms.Label URI;
        private System.Windows.Forms.Label ContentData;
        private System.Windows.Forms.DataGridViewTextBoxColumn ApiDirection;
        private System.Windows.Forms.DataGridViewTextBoxColumn Verb;
        private System.Windows.Forms.DataGridViewTextBoxColumn Resource;
    }
}

