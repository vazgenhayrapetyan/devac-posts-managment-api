<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'name' => 'User',
            'email' => 'user@devaac.am',
            'password' => Hash::make('user123'),
            'role' => 'user',
        ]);
        User::create([
            'name' => 'Admin',
            'email' => 'admin@devaac.am',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
        ]);
        User::create([
            'name' => 'Editor',
            'email' => 'editor@devaac.am',
            'password' => Hash::make('editor123'),
            'role' => 'editor',
        ]);
    }
}
