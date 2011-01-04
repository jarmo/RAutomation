
Before do
  @sample_app_pid = IO.popen(SAMPLE_APP_EXE).pid
  if @sample_app_pid == 0
    fail "Could not start #{SAMPLE_APP_EXE}"
  end
end

After do
  Process.kill(9, @sample_app_pid) rescue nil
end
