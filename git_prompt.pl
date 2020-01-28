#! /usr/bin/env perl

@ARROW = qw / == <- -> <=> /;

chomp(my @git_status = `git status -b --porcelain=v2 2> /dev/null`);
exit if $? != 0;

my @git_prompt;

# branch message
for (qw / head ab upstream /) {
    my $pattern = "^# branch." . $_;

    if (/^ab$/) {
        my $arrow;

        my $branch_ab = (grep /$pattern/, @git_status)[0];
        if ($branch_ab ne '') {
            $arrow = $ARROW[0];
            $arrow = $ARROW[1] if ($branch_ab =~ /\+[1-9]+/);
            $arrow = ($arrow eq $ARROW[1]) ? $ARROW[3]: $ARROW[2] if ($branch_ab =~ /-[1-9]+/);
        }

        push @git_prompt, ($arrow);
    } else {
        push @git_prompt, (split / /, (grep /$pattern/, @git_status)[0])[-1];
    }
}

my $git_prompt = join ' ', @git_prompt;
print $git_prompt . "\n";
