# DockerのImage以外で自分で追加したものはレイヤーファイルとしてS3に保存される
# dockerをpullするタイミングでレイヤーファイルをS3から取得する為にS3とのプライベート接続リソースを作成する

resource "aws_vpc_endpoint" "geocache_s3" {
  vpc_id = aws_vpc.geocache.id # どのVPCに紐づいているか
  service_name = "com.amazonaws.ap-northeast-1.s3" # どのサービスと接続するエンドポイントか
  route_table_ids = [aws_route_table.geocache_private.id] # どのルーティングIDを利用するか
}