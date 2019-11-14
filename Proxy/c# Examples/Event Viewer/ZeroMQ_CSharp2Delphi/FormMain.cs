using System;
using System.Windows.Forms;
using System.Threading;
using NetMQ;
using NetMQ.Sockets;

namespace ZeroMQ_CSharp2Delphi
{
    public partial class FormMain : Form
    {
        public FormMain()
        {
            InitializeComponent();
        }

        public void TestServerReceiveReply()
        {

            //
            // Hello World server
            //
            //rtbStatus.AppendText("Server started");

            // Create
            using (var responder = new ResponseSocket())
            {
                // Bind
                responder.Bind("tcp://*:5555");

                while (true)
                {
                    // Receive
                    //Msg MyMessage;
                    //TimeSpan timeout = new TimeSpan(60000);
                    var message = responder.ReceiveFrameString();
                   // rtbStatus.AppendText("Received " + message);
                    
                    // Do some work
                    Thread.Sleep(1000);

                    // Send
                    responder.SendFrame("Hello from C#: " + message);
                }
            }
        }

        private void TestClientSendReceive()
        {
            //
            // Hello World client
            //
            // Author: metadings
            //
            // Create
            using (var requester = new RequestSocket())
            {
                // Connect
                requester.Connect("tcp://localhost:5566");
                bool abort = false;
                for (int n = 0; (n < 10) && !abort; ++n)
                {
                    string requestText = String.Format("{0}: {1}", TbxSendMessage.Text, n);
                    MessageBox.Show("Sending: " + requestText);

                    // Send
                    requester.SendFrame(requestText);
                    Thread.Sleep(1000);

                    // Receive
                    try
                    {
                        string replyText = requester.ReceiveFrameString();
                        MessageBox.Show("Received: " + replyText);
                        /*
                        if (requester.TryReceiveFrameString(out replyText))
                            //rtbStatus.AppendText("Received: " + replyText + "\r\n");                        
                            MessageBox.Show("Received: " + replyText);
                        else
                        {
                            //rtbStatus.AppendText("No message Received!\r\n");
                            MessageBox.Show("No message Received!");
                            abort = true;
                        }
                        */

                    }
                    catch (NetMQException)
                    {
                        MessageBox.Show("NetMQException raised");
                        abort = true;
                    }
                }
            }
        }
        private void BtnStartServer_Click(object sender, EventArgs e)
        {
            Thread ZMQThread = new Thread(TestServerReceiveReply);
            ZMQThread.Start();
        }

        private void BtnSendMessage_Click(object sender, EventArgs e)
        {
            Thread ZMQThread = new Thread(TestClientSendReceive);
            ZMQThread.Start();
        }
    }
}

    

