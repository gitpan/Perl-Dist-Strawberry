package Perl::Dist::Strawberry::Step::OutputZIP;

use 5.012;
use warnings;
use base 'Perl::Dist::Strawberry::Step';

use File::Spec::Functions qw(catfile);

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  return $self;
}

sub run {
  my $self = shift;
  
  if ($self->global->{target} !~ /zip/) {
    $self->boss->message(2, "skipping as 'zip' target disabled");
    return;
  }
  
  my $output_basename = $self->global->{output_basename} // 'perl-output';
  my $zip_file = catfile($self->global->{output_dir}, "$output_basename.zip");
  
  $self->boss->message(2, "gonna create '$zip_file'"); 
  # backup already existing zip_file;  
  $self->backup_file($zip_file);
  # do zip
  $self->boss->zip_dir($self->global->{image_dir}, $zip_file, 9); # 9 = max. compression  
  #store results
  $self->{data}->{output}->{zip} = $zip_file;
  $self->{data}->{output}->{zip_sha1} = $self->sha1_file($zip_file);
}

1;