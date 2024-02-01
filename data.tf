//  data "aws_ami" "ubuntu" {
//   most_recent = true

//   filter {
//     name   = "name"
//     values = ["terraform-ubuntu-dev"]
//   }

//   filter {
//     name   = "virtualization-type"
//     values = ["hvm"]
//   }

//   owners = ["099720109477"]  
// }



// data "aws_ami" "rhel" {
//   most_recent = true

//   filter {
//     name   = "Name=tag:Type"
//     values = ["terraform-rhel-dev"]
//   }

//   filter {
//     name   = "virtualization-type"
//     values = ["hvm"]
//   }

//   owners = ["309956199498"]
// }


// data "aws_ami" "bastion" {
//   most_recent = true

//   filter {
//     name   = "Name=tag:Type"
//     values = ["terraform-bastion-dev"]
//   }

//   filter {
//     name   = "virtualization-type"
//     values = ["hvm"]
//   }

//   owners = ["309956199498"]
// }