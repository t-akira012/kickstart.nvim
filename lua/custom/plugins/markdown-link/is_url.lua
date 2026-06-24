local function is_url(str)
  if not str or str == '' then
    return false
  end

  -- スキーム付き: https?://, file:///, s3://
  if str:match '^https?://' then
    return true
  end
  if str:match '^file:///' then
    return true
  end
  if str:match '^s3://' then
    return true
  end

  -- localhost
  if str:match '^localhost' then
    return true
  end

  -- IPアドレス (簡易: 数字.数字.数字.数字)
  if str:match '^%d+%.%d+%.%d+%.%d+' then
    return true
  end

  -- FQDN (ドットを含み、スペースを含まない)
  if not str:match '%s' and str:match '%.' then
    return true
  end

  return false
end

return is_url
