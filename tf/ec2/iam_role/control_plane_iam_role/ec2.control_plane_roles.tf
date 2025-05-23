resource "aws_iam_role" "control_plane_role" {
  name = "control_plane_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.control_plane_role.name
}

resource "aws_iam_role_policy_attachment" "control_plane_AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.control_plane_role.name
}

resource "aws_iam_role_policy_attachment" "control_plane_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.control_plane_role.name
}



resource "aws_iam_instance_profile" "control_plane_profile" {
  name = "control_plane_profile"
  role = aws_iam_role.control_plane_role.name
}

