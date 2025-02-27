<?php
require_once "config.php";
?>

<!DOCTYPE html>
<html lang="de">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo getenv("APP_NAME"); ?></title>
</head>

<body>
    <header>
        <h1>Willkommen auf meiner PHP-Seite</h1>
    </header>
    <main>
        <p>Heute ist der <strong><?php echo date("d.m.Y"); ?></strong></p>
        <?php
        // Beispiel einer kleinen PHP-Funktion
        function begruessung()
        {
            $stunde = date("H");
            if ($stunde < 12) {
                return "Guten Morgen!";
            } elseif ($stunde < 18) {
                return "Guten Tag!";
            } else {
                return "Guten Abend!";
            }
        }
        ?>
        <p><?php echo begruessung(); ?></p>
    </main>
    <footer>
        <p>&copy; <?php echo date("Y"); ?> Meine PHP-Seite</p>
    </footer>
</body>

</html>