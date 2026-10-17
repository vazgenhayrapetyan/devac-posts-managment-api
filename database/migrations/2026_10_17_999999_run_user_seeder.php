<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Artisan;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Սա ավտոմատ կկանչի ձեր UserSeeder-ը, երբ Render-ը թարմանա
        Artisan::call('db:seed', [
            '--class' => 'UserSeeder',
            '--force' => true
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
