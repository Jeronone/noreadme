AWS.config(access_key_id:     ENV['AKIAI4AKW43PXCSKQFHA'],
           secret_access_key: ENV['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'] )

S3_BUCKET = AWS::S3.new.buckets[ENV['BUCKET15-7-14']]