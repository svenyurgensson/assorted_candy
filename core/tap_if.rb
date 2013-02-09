# Taken from https://github.com/bnorton/tap_if/blob/master/lib/tap_if.rb

module ASOS
  module Core
    module TapIf
      # Executes the given block if the `caller` is truthy or given the `method name + args` evaluate to
      # a truthy value.
      #
      # Useful for clarity - always return the caller but only
      # execute the block when the condition passes.
      #
      # Update the user's account token if the user is an admin of the account.
      #
      # User.find(user_id).tap_if(:admin?, account) do |user|
      # user.update_token(account)
      # end
      #
      # Only update twitter/facebook if the post actually publishes.
      #
      # def publish
      # (post.pending? && post.update_attributes(:published => true)).tap_if do
      # the_update = "New blog post: #{post.title[0..100]}... #{post.link}"
      #
      # Twitter.update(the_update)
      # Facebook.update(the_update)
      # end
      # end

      def tap_if(*args)
        yield self if (args.empty? && self || args.any? && respond_to?(args.first) && send(*args))
        self
      end

    end # module TapIf
  end
end

Object.send(:include, AssortedCandy::Core::TapIf)


if __FILE__ == $0
  def check predicat
    predicat ? 'proved' : 'not proven'
  end



  puts check( true  )

end
