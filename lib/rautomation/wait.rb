module RAutomation
  module WaitHelper
    class TimeoutError < StandardError
    end

    #
    # Wait until the block evaluates to true or times out.
    #
    def wait_until(timeout = 60, &block)
      end_time = ::Time.now + timeout

      until ::Time.now > end_time
        result = yield(self)
        return result if result
        sleep 0.1
      end

      raise TimeoutError, "timed out after #{timeout} seconds"
    end

    def wait_until?(timeout = 60, &block)
      wait_until(timeout, &block)
      true
    rescue TimeoutError
      false
    end
  end
end