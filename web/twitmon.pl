#!/usr/bin/perl
my $twitter_key = 'REDACTED';
my $twitter_secret = 'REDACTED';
my $twitter_bearer_token = 'REDACTED';
@user_ids = ('1013821250945220608', '3339261074', '99247845', '3808509013', '3074375149', '14154640', '40137006', '1427434435587153925', '1100933556522508288');
my %tweet_ids;
my $bells = q^'playsound minecraft:block.bell.use master @a' 'playsound minecraft:block.bell.use master @a' 'playsound minecraft:block.bell.use master @a'^;
my $message = 'tellraw @a {"text":"A new tweet from a scavenger hunt account (clickable):","bold":true,"color":"red"}';
my $open_message = 'tellraw @a {"text":"The latest question is now OPEN!","bold":true,"color":"green"}';
my $question_is_open = 'false';
my $start_time = 1639094340;    #1636977540 60 sec before Q3 opens
my $end_time = $start_time + ((6 * 60) * 60);
my $leak_message = 'tellraw @a {"text":"The answer to the current question has already leaked.","color":"yellow"}';
my $leaked_indicator = './leaked';

use JSON;


sub get_recent_tweets() {
    foreach (@user_ids) {
        my $tweet = decode_json(`curl -s "https://api.twitter.com/2/users/$_/tweets?max_results=5" -H "Authorization: Bearer $twitter_bearer_token"`);
        $tweet_id = $tweet->{data}[0]->{id};
        if (not(exists($tweet_ids{$tweet_id}))) {
            print "adding $tweet_id\n";
            $tweet_ids{$tweet_id} = 'clean';
        }
    }
}

print `mcrcon -H 0.0.0.0 -P 25575 -p REDACTED -w 1 $bells`;
my $init_message = 'tellraw @a {"text":"Intel Xe-HPG Hunt Twitter monitor has started.","color":"yellow"}';
print `mcrcon -H 0.0.0.0 -P 25575 -p REDACTED -w 1 '$init_message'`;
for (;;) {
    if (not(-e $leaked_indicator)) {
        if ((time() gt $start_time) and (time() lt $end_time)) {
            if (question_is_open eq 'false') {
                get_recent_tweets();
                print `mcrcon -H 0.0.0.0 -P 25575 -p REDACTED -w 1 $bells`;
                print `mcrcon -H 0.0.0.0 -P 25575 -p REDACTED -w 1 '$open_message'`;
                $question_is_open = 'true';
                for (keys %tweet_ids) {
                    print "key: ".$_."\n";
                    $tweet_ids{$_} = 'dirty';
                }
                sleep(10);
            }
            get_recent_tweets();
        }
        for (keys(%tweet_ids)) {
            if (($tweet_ids{$_} eq 'clean') and ($_ ne '0')) {
                $linkmessage = 'tellraw @a {"text":"replace","italic":true,"underlined":true,"color":"aqua","clickEvent":{"action":"open_url","value":"replace"}}';
                $tweetlink = "https://twitter.com/a/status/$_";
                $linkmessage =~ s/replace/$tweetlink/ig;
                print `mcrcon -H 0.0.0.0 -P 25575 -p REDACTED -w 1 $bells`;
                print `mcrcon -H 0.0.0.0 -P 25575 -p REDACTED -w 1 '$message'`;
                print `mcrcon -H 0.0.0.0 -P 25575 -p REDACTED -w 1 '$linkmessage'`;
                $tweet_ids{$_} = 'dirty';
                print "".$tweet_ids{$_}."\n";
            }
        }
        sleep(60);
    } else {
        print `mcrcon -H 0.0.0.0 -P 25575 -p REDACTED -w 1 '$leak_message'`;
        sleep(300);
    }

}
