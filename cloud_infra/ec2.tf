provider "aws" {
  region   = "ap-south-1"
   profile  = "dev"
}



resource "aws_instance" "thor" {
 

    ami = "ami-0447a12f28fddb066"
    instance_type = "t2.micro"
     key_name  ="newoskey"
     availability_zone="ap-south-1a"
     security_groups = ["my_SG"]
     

    connection {
      type  = "ssh"
       user = "ec2-user"
      private_key = file("C:/Users/Prashant/Downloads/newoskey.pem")
       host = aws_instance.thor.public_ip
   }


 provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd  php git -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
    "sudo git clone https://github.com/Dev2108/multicloud.git /var/www/html"
    ]
  }

  tags = {
          Name = "taskos"
  }
}


resource "aws_ebs_volume" "esb2" {
  availability_zone = aws_instance.thor.availability_zone
  size              = 1
  tags = {
    Name = "lwebs"
  }
}




resource "aws_volume_attachment" "ebs_att2" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.esb2.id
  instance_id = aws_instance.thor.id
  force_detach = true
}


output "myos_ip" {
  value = aws_instance.thor.public_ip
}


resource "null_resource" "nulllocal2"  {
	provisioner "local-exec" {
	    command = "echo  ${aws_instance.thor.public_ip} > publicip.txt"
  	}
}



resource "null_resource" "mounting"  {

depends_on = [
    aws_volume_attachment.ebs_att2,
  ]


  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Prashant/Downloads/newoskey.pem")
    host     = aws_instance.thor.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4  /dev/xvdh",
      "sudo mount  /dev/xvdh /var/www/html",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/Dev2108/multicloud.git /var/www/html"
      
    ]
  }
}
