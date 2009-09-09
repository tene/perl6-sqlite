module SQLite3 {

    use SQLite3:from<parrot>;

    class STH {
        has $!handle;

        method step {
            SQLite3::step($!handle);
        }

        method finalize {
            SQLite3::finalize($!handle);
        }

        method column_count {
            SQLite3::column_count($!handle);
        }

        method column_name(Int $pos) {
            SQLite3::column_name($!handle, $pos);
        }

        method column_text(Int $pos) {
            SQLite3::column_text($!handle, $pos);
        }

        multi method bind(Int $pos, Int $n) {
            SQLite3::bind_int($!handle, $pos, $n);
        }

        # Might not work...
        multi method bind(Int $pos, Str $text) {
            SQLite3::bind_text($!handle, $pos, $text, bytes($text), -1);
        }
    }
    class DBH {
        has $!handle;

        method prepare($sql) {
            SQLite3::STH.new(:handle(SQLite3::prepare($!handle, $sql)));
        }

        method close {
            SQLite3::close($!handle);
        }
    }

    sub sqlite_open($file) is export {
        my $handle = SQLite3::open($file);
        SQLite3::DBH.new(:handle($handle));
    }

}
# vim: ft=perl6
