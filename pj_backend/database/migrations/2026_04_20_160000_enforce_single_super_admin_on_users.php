<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $driver = DB::getDriverName();
        $keeperId = DB::table('users')
            ->where('role', 'super_admin')
            ->orderBy('id')
            ->value('id');

        if ($keeperId !== null) {
            DB::table('users')
                ->where('role', 'super_admin')
                ->where('id', '!=', $keeperId)
                ->update([
                    'role' => 'staff',
                    'admin_key_hash' => null,
                    'updated_at' => now(),
                ]);
        }

        if (in_array($driver, ['pgsql', 'sqlite'], true)) {
            DB::statement("CREATE UNIQUE INDEX users_single_super_admin_idx ON users (role) WHERE role = 'super_admin'");
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        $driver = DB::getDriverName();

        if (in_array($driver, ['pgsql', 'sqlite'], true)) {
            DB::statement('DROP INDEX IF EXISTS users_single_super_admin_idx');
        }
    }
};
