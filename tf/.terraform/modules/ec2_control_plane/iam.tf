resource "aws_iam_role" "control_plane_role" {
  name = "control_plane_role"
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

resource "aws_iam_role_policy_attachment" "control_plane_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.control_plane_role.name
}

resource "aws_iam_role_policy_attachment" "ebs" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "control_plane_profile" {
  name = "control_plane_profile"
  role = aws_iam_role.control_plane_role.name
}