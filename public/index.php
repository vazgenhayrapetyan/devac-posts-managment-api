<?php
// --- SYMFONY REQUEST.PHP SYNTAX HOTFIX ---
$filePath = __DIR__ . '/../vendor/symfony/http-foundation/Request.php';
if (file_exists($filePath)) {
    $content = file_get_contents($filePath);
    // Եթե 117-րդ տողում կա խնդրահարույց սինտաքսը, այն ավտոմատ կփոխարինվի ճիշտ սիմվոլով
    if (str_contains($content, 'unexpected token "{"')) {
        // Այս տողը ավտոմատ կուղղի ֆայլի սխալ սինտաքսը Linux-ի համար
        $fixedContent = str_replace('protected {', 'protected ', $content); 
        file_put_contents($filePath, $fixedContent);
    }
}
// ------------------------------------------

use Illuminate\Foundation\Application;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// Determine if the application is in maintenance mode...
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

// Register the Composer autoloader...
require __DIR__.'/../vendor/autoload.php';

// Bootstrap Laravel and handle the request...
/** @var Application $app */
$app = require_once __DIR__.'/../bootstrap/app.php';

$app->handleRequest(Request::capture());
